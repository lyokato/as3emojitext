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

        public function EmojiTextAreaBuilder()
        {
            _spriteStore = {};
            _uriStore    = [];
            _loading     = false;
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
                var textarea:EmojiTextArea = new EmojiTextArea(engine);
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


/*

var builder = new EmojiTextAreaBuilder();

builder.registerByURI('[m:26]', '');
builder.registerByURI('[m:59]', '');
builder.registerByURI('[]', '');

builder.addEventListener(IOErrorEvent.IO_ERROR);
builder.addEventListener(SecurityErrorEvent.SECURITY_ERROR);
builder.addEventListener(EmojiTextAreaBuilderEvent.BUILT, builtHandler);

builder.buildAsync();

private function builtHandler(e:EmojiTextAreaBuilderEvent):void
{
    _emojiTextArea = e.textArea;
    _emojiTextArea.lineHeight = 20;
    container.addChild(_emojiTextArea);
}

_emojiTextArea.text = "ほげ[m:25]ほげ";

*/

