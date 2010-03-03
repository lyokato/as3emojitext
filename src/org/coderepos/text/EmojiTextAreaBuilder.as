/*
Copyright (c) Lyo Kato (lyo.kato _at_ gmail.com)

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package org.coderepos.text
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.display.Sprite;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.system.LoaderContext;
    import flash.net.URLRequest;

    import org.coderepos.text.events.EmojiTextAreaBuildEvent;

    public class EmojiTextAreaBuilder extends EventDispatcher
    {
        private var _spriteStore:Object; // map<Pattern, Sprite>
        private var _uriStore:Array;
        private var _loading:Boolean;
        private var _loader:Loader;
        private var _currentPatern:String;
        private var _width:uint;
        private var _height:uint;

        public function EmojiTextAreaBuilder(width:uint, height:uint)
        {
            _spriteStore = {};
            _uriStore    = [];
            _loading     = false;
            _width       = width;
            _height      = height;
        }

        public function clear():void
        {
            _spriteStore = {};
            _uriStore    = [];
            _loading     = false;
        }

        public function registerByURI(pattern:String, uri:String):void
        {
            // TODO: validation for params
            _uriStore.push([pattern, uri]);
        }

        public function registerBySprite(pattern:String, shape:Sprite):void
        {
            _spriteStore[pattern] = shape;
        }

        public function buildAsync():void
        {
            if (_loading)
                throw new Error("loading");

            loadNextURI();
        }

        private function loadNextURI():void
        {
            if (_uriStore.length > 0) {

                var pair:Array = _uriStore.shift();
                _currentPatern = pair[0];
                _loader = new Loader();
                _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
                _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                _loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
                _loader.load(new URLRequest(pair[1]), new LoaderContext(true));

            } else {

                _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
                _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                _loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);

                var engine:EmojiTextEngine = new EmojiTextEngine(_spriteStore);
                var textarea:EmojiTextArea = new EmojiTextArea(engine, _width, _height);
                clear();
                dispatchEvent(new EmojiTextAreaBuildEvent(EmojiTextAreaBuildEvent.BUILT, textarea));
            }
        }

        private function completeHandler(e:Event):void
        {
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
            _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);

            var bitmap:Bitmap;
            var bitmapData:BitmapData = new BitmapData(_loader.width, _loader.height, true, 0x00000000);
            try {
                bitmapData.draw(_loader);
                bitmap = new Bitmap(bitmapData);
                bitmap.smoothing = true;
                _spriteStore[_currentPatern] = bitmap;
            } catch (error:*) {
                if (error is SecurityErrorEvent) {
                    _spriteStore[_currentPatern] = _loader;
                } else {
                    clear();
                    // XXX: or dispatch error-event?
                    throw error;
                }
            }

            loadNextURI();
        }

        private function ioErrorHandler(e:IOErrorEvent):void
        {
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
            _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            clear();
            dispatchEvent(e);
        }

        private function securityErrorHandler(e:SecurityErrorEvent):void
        {
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
            _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            clear();
            dispatchEvent(e);
        }
    }
}

