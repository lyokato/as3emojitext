package org.coderepos.text
{
    public class EmojiPatternFormat
    {
        private var _prefix:String;
        private var _suffix:String;

        // now suffix must be single Char
        public function EmojiPatternFormat(prefix:String, suffix:String)
        {
            if (prefix.length < 1)
                throw new ArgumentError("prefix length should be greater than 1.");

            if (suffix.length != 1)
                throw new ArgumentError("suffix should be 1 character");

            _prefix = prefix.replace(/([^0-9a-zA-Z_])/g, "\\$1");
            _suffix = suffix.replace(/([^0-9a-zA-Z_])/g, "\\$1");
        }

        public function toRegExpString():String
        {
            return _prefix + '([^' + _suffix + ']*)' + _suffix;
        }
    }
}

