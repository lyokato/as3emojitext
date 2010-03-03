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
    import flash.display.Sprite;
    import flash.text.engine.ElementFormat;
    import flash.text.engine.FontDescription;
    import flash.text.engine.ContentElement;
    import flash.text.engine.TextElement;
    import flash.text.engine.TextBlock;
    import flash.text.engine.TextJustifier;
    import flash.text.engine.TextLine;
    import flash.text.engine.GraphicElement;
    import flash.text.engine.GroupElement;

    public class EmojiTextArea extends Sprite
    {
        private var _engine:EmojiTextEngine;
        private var _lines:Vector.<TextLine>;
        private var _format:ElementFormat;
        private var _lineHeight:uint;
        private var _justifier:TextJustifier;

        public function EmojiTextArea(engine:EmojiTextEngine, w:uint, h:uint)
        {
            _engine     = engine;
            _lines      = new Vector.<TextLine>();
            _format     = new ElementFormat();
            _lineHeight = 20;


            var dummy:Sprite = new Sprite();
            dummy.graphics.lineStyle(1, 0xFFFF00);
            dummy.graphics.drawRect(0 , 0, w, h);
            dummy.alpha = 0;
            addChild(dummy);

            width  = w;
            height = h;
        }

        public function set justifier(justifier:TextJustifier):void
        {
            _justifier = justifier;
        }

        /* Proxy to format */
        public function set alignmentBaseline(baseLine:String):void
        {
            _format.alignmentBaseline = baseLine;
        }

        public function get alignmentBaseline():String
        {
            return _format.alignmentBaseline;
        }

        /*
        public function set alpha(n:Number):void
        {
            _format.alpha = n;
        }

        public function get alpha():Number
        {
            return _format.alpha;
        }
        */

        public function set baselineShift(n:Number):void
        {
            _format.baselineShift = n;
        }

        public function get baselineShift():Number
        {
            return _format.baselineShift;
        }

        public function set breakOpportunity(opp:String):void
        {
            _format.breakOpportunity = opp;
        }

        public function get breakOpportunity():String
        {
            return _format.breakOpportunity;
        }

        public function set color(c:uint):void
        {
            _format.color = c;
        }

        public function get color():uint
        {
            return _format.color;
        }

        public function set digitCase(s:String):void
        {
            _format.digitCase = s;
        }

        public function get digitCase():String
        {
            return _format.digitCase;
        }

        public function set digitWidth(s:String):void
        {
            _format.digitWidth = s;
        }

        public function get digitWidth():String
        {
            return _format.digitWidth;
        }

        public function set dominantBaseline(s:String):void
        {
            _format.dominantBaseline = s;
        }

        public function get dominantBaseline():String
        {
            return _format.dominantBaseline;
        }

        public function set fontDescription(desc:FontDescription):void
        {
            _format.fontDescription = desc;
        }

        public function get fontDescription():FontDescription
        {
            return _format.fontDescription;
        }

        public function set fontSize(n:Number):void
        {
            _format.fontSize = n;
        }

        public function get fontSize():Number
        {
            return _format.fontSize;
        }

        public function set kerning(s:String):void
        {
            _format.kerning = s;
        }

        public function get kerning():String
        {
            return _format.kerning;
        }

        public function set ligatureLevel(s:String):void
        {
            _format.ligatureLevel = s;
        }

        public function get ligatureLevel():String
        {
            return _format.ligatureLevel;
        }

        public function set locale(s:String):void
        {
            _format.locale = s;
        }

        public function get locale():String
        {
            return _format.locale;
        }

        public function set locked(b:Boolean):void
        {
            _format.locked = b;
        }

        public function get locked():Boolean
        {
            return _format.locked;
        }

        public function set textRotation(s:String):void
        {
            _format.textRotation = s;
        }

        public function get textRotation():String
        {
            return _format.textRotation;
        }

        public function set trackingLeft(n:Number):void
        {
            _format.trackingLeft = n;
        }

        public function get trackingLeft():Number
        {
            return _format.trackingLeft;
        }

        public function set trackingRight(n:Number):void
        {
            _format.trackingRight = n;
        }

        public function get trackingRight():Number
        {
            return _format.trackingRight;
        }

        public function set typographicCase(s:String):void
        {
            _format.typographicCase = s;
        }

        public function get typographicCase():String
        {
            return _format.typographicCase;
        }

        public function set lineHeight(h:uint):void
        {
            _lineHeight = h;
        }

        private function clearLines():void
        {
            for each(var line:TextLine in _lines)
                removeChild(line);
            _lines = new Vector.<TextLine>();
        }

        public function set text(str:String):void
        {
            clearLines();

            var textBlock:TextBlock = new TextBlock();
            if (_justifier != null)
                textBlock.textJustifier = _justifier;
            textBlock.content = _engine.genGroupElement(str, _format);
            var line:TextLine = textBlock.createTextLine(null, width);
            var xPos:int = 0;
            var yPos:int = 0;
            while (line != null) {
                _lines.push(line);
                addChild(line);
                line.x = xPos;
                line.y = yPos;
                yPos += _lineHeight;
                line = textBlock.createTextLine(line, width);
            }
        }
    }
}

