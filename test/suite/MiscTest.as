package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.text.EmojiTextAreaBuilder;
    import org.coderepos.text.EmojiTextArea;
    import org.coderepos.text.EmojiTextEngine;

    public class MiscTest extends TestCase {
        public function MiscTest(meth:String) {
            super(meth);
        }

        public static function suite():TestSuite {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new MiscTest("testMisc"));
            return ts;
        }

        public function testMisc():void
        {
            var r:RegExp = new RegExp('\\[m\\:([^\\]]*)\\]|\\[a\\:([^\\]]*)\\]', 'g');

            var str:String = "hoge[m:46]aaa[a:50]";
            var result:Object = r.exec(str);
            assertNotNull('first test returns not null', result);
            //assertEquals('first test index', 20, result.index);
            assertEquals('first test matched DEFG', '46', result[1]);
            assertNull('first test matched DEFG', result[2]);
            result = r.exec(str);
            assertNotNull('first test returns not null', result);
            assertNull('first test matched DEFG', result[1]);
            assertEquals('first test matched DEFG', '50', result[2]);
        }
    }
}
