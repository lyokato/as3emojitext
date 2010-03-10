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
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.system.LoaderContext;
    import flash.net.URLRequest;

    import org.coderepos.text.events.EmojiTextAreaBuildEvent;

    public class EmojiTextAreaBuilder extends EventDispatcher
    {
        private var _shapeMap:Object;
        private var _uriStore:Array;
        private var _loading:Boolean;
        private var _loader:Loader;
        private var _currentPattern:Array;
        private var _width:uint;
        private var _height:uint;
        private var _formatIDPod:uint;
        private var _formats:Array;

        public function EmojiTextAreaBuilder(width:uint, height:uint)
        {
            _shapeMap    = {};
            _uriStore    = [];
            _loading     = false;
            _width       = width;
            _height      = height;
            _formatIDPod = 1;
            _formats     = [];
        }

        public function genPatternFormat(prefix:String, suffix:String):uint
        {
            var formatID:uint = _formatIDPod++;
            _formats.push(new EmojiPatternFormat(prefix, suffix));
            return formatID;
        }

        public function clear():void
        {
            _shapeMap = {};
            _uriStore = [];
            _loading  = false;
        }

        public function registerByURI(formatID:uint, pattern:String, uri:String):void
        {
            // TODO: validation for params
            if (formatID > _formatIDPod)
                throw new ArgumentError("Unknown format-ID: " + String(formatID));
            _uriStore.push([formatID, pattern, uri]);
        }

        public function registerByDisplayObject(formatID:uint, pattern:String,
            shape:DisplayObject):void
        {
            if (formatID > _formatIDPod)
                throw new ArgumentError("Unknown format-ID: " + String(formatID));

            if (!(formatID in _shapeMap))
                _shapeMap[formatID] = {};
            _shapeMap[formatID][pattern] = shape;
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
                _currentPattern = pair;
                _loader = new Loader();
                _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
                _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                _loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
                _loader.load(new URLRequest(pair[2]), new LoaderContext(true));

            } else {

                if (_loader != null) {
                    _loader.contentLoaderInfo.removeEventListener(
                        Event.COMPLETE, completeHandler);
                    _loader.contentLoaderInfo.removeEventListener(
                        IOErrorEvent.IO_ERROR, ioErrorHandler);
                    _loader.contentLoaderInfo.removeEventListener(
                        SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
                }

                var engine:EmojiTextEngine = new EmojiTextEngine(_formats, _shapeMap);
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
                registerByDisplayObject(_currentPattern[0], _currentPattern[1], DisplayObject(bitmap));
            } catch (error:*) {
                if (error is SecurityErrorEvent) {
                    registerByDisplayObject(_currentPattern[0], _currentPattern[1], DisplayObject(_loader));
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

