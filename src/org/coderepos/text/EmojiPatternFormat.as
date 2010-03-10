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

