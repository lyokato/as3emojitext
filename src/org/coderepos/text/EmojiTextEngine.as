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

        public function EmojiTextEngine(map:Object)
        {
            _map = map;
            var patterns:Vector.<String> = new Vector.<String>();
            for (var pattern:String in _map) {
                // quotemeta
                pattern = pattern.replace(/([^0-9a-zA-Z_])/g, "\\$1");
                patterns.push("(" + pattern + ")");
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
                    var symbol:DisplayObject = _map[matched];
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
    }
}

