package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    import org.coderepos.text.EmojiTextAreaBuilder;
    import org.coderepos.text.EmojiTextArea;
    import org.coderepos.text.EmojiTextEngine;
    import org.coderepos.text.EmojiPatternFormat;

    public class LoadTest extends TestCase {
        public function LoadTest(meth:String) {
            super(meth);
        }

        public static function suite():TestSuite {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new LoadTest("testLoad"));
            return ts;
        }

        public function testLoad():void
        {
            var builder:EmojiTextAreaBuilder = new EmojiTextAreaBuilder(500, 200);
            assertEquals('', '');
        }
    }
}
