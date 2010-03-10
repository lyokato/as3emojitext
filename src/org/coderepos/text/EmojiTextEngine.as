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
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.text.engine.ElementFormat;
    import flash.text.engine.ContentElement;
    import flash.text.engine.TextElement;
    import flash.text.engine.GraphicElement;
    import flash.text.engine.GroupElement;

    public class EmojiTextEngine
    {
        private var _map:Object;
        private var _pattern:String;
        private var _patternLength:uint;

        public function EmojiTextEngine(formats:Array, map:Object)
        {
            _map = map;
            for (var propID:String in _map) {
               for (var prop:String in _map[propID]) {
               }
            }
            _patternLength = formats.length + 1;
            var patterns:Array = [];
            for each(var format:EmojiPatternFormat in formats) {
                patterns.push(format.toRegExpString());
            }
            _pattern = patterns.join("|");
        }

        public function genGroupElement(src:String, format:ElementFormat):GroupElement
        {
            var pattern:RegExp = new RegExp(_pattern, "g");
            var groupVector:Vector.<ContentElement> = new Vector.<ContentElement>();
            var lastIndex:int = 0;
            var textPart:String;
            var result:Object = pattern.exec(src);
            if (result == null) {
                groupVector.push(new TextElement(src, format));
            } else {
                while (result != null) {
                    if (lastIndex != result.index) {
                        // textpart
                        textPart = src.substring(lastIndex, result.index);
                        groupVector.push(new TextElement(textPart, format));
                    }
                    var matched:String = result[0];
                    lastIndex = result.index + matched.length;
                    // graphic part
                    //var symbol:DisplayObject = _map[matched];
                    var symbol:DisplayObject = findMatchedSymbol(result);
                    if (symbol != null)
                        groupVector.push(new GraphicElement(symbol,
                            symbol.width, symbol.height, format));
                    result = pattern.exec(src);
                }
                if (lastIndex < src.length) {
                    textPart = src.substring(lastIndex);
                    groupVector.push(new TextElement(textPart, format));
                }
            }
            return new GroupElement(groupVector);
        }

        private function findMatchedSymbol(result:Object):DisplayObject
        {
            for (var i:uint = 1; i < _patternLength; i++) {
                var matched:String = result[i];
                if (matched != null && i in _map) {
                    return (matched in _map[i]) ? _map[i][matched] : null;
                }
            }
            return null;
        }
    }
}

