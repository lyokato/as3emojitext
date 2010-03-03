package org.coderepos.text.events
{
    import flash.events.Event;
    import org.coderepos.text.EmojiTextArea;

    public class EmojiTextAreaBuildEvent extends Event
    {
        public static const BUILT:String = "built";

        private var _textArea:EmojiTextArea;

        public function EmojiTextAreaBuildEvent(type:String, area:EmojiTextArea,
            bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            _textArea = area;
        }

        public function get textArea():EmojiTextArea
        {
            return _textArea;
        }
    }
}

