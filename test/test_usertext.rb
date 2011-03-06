require 'helper'

class TestUsertext < Test::Unit::TestCase

  should "test that the gem has been loaded okay" do
    
    assert_equal "", Usertext.new("").to_html
    
  end

  should "Insert paragraph tags" do
    assert_equal("<p>Hello!</p>", Usertext.new("Hello!").to_html)
  end
  
  should "Insert two paragraph tags" do
    assert_equal("<p>Hello!</p>\n\n<p>Wow!</p>", Usertext.new("Hello!\n\nWow!").to_html)
  end
  
  should "Insert three paragraph tags" do
    assert_equal("<p>Hello!</p>\n\n<p>Wow!</p>\n\n<p>Woop!</p>", 
      Usertext.new("Hello!\n\nWow!\n\nWoop!").to_html)
  end
  
  should "Insert four paragraph tags" do
    assert_equal("<p>Hello!</p>\n\n<p>Wow!</p>\n\n<p>Woop!</p>\n\n<p>Pow!</p>", 
      Usertext.new("Hello!\n\nWow!\n\nWoop!\n\nPow!").to_html)
  end

  def test_elipsis_insertion
    assert_equal "<p>I eat… worms!</p>", Usertext.new("I eat... worms!").to_html
  end

  def test_elipsis_insertion_at_end_of_string
    assert_equal "<p>I want to…</p>", Usertext.new("I want to...").to_html
  end

  def test_insert_typographic_apostrophe
    assert_equal "<p>Jamie’s house</p>", Usertext.new("Jamie's house").to_html
  end
  
  def test_insert_typographic_apostrophe_in_decade_reference
    assert_equal "<p>It was acceptable in the ’80s.</p>", Usertext.new("It was acceptable in the '80s.").to_html
  end
  
  def test_insert_typographic_double_quotes
    assert_equal "<p>She said “hello”.</p>", Usertext.new("She said \"hello\".").to_html
  end
  
  def test_insert_typographic_single_quotes
    assert_equal "<p>She said ‘hello’.</p>", Usertext.new("She said 'hello'.").to_html
  end  
  
  def test_insert_multiplication_character
    assert_equal "<p>2×2=4</p>", Usertext.new("2x2=4").to_html
  end
  
  def test_insert_figure_dash
    assert_equal "<p>Telephone 867‒5309.</p>", Usertext.new("Telephone 867-5309.").to_html
  end
  
  def test_insert_en_dash
    assert_equal "<p>For ages 3–5.</p>", Usertext.new("For ages 3-5.").to_html
  end
  
  def test_insert_em_dash
    assert_equal "<p>I am not sure—although I really should be—what to do.</p>", Usertext.new("I am not sure--although I really should be--what to do.").to_html
  end
  


  def test_insert_degrees_symbol
    assert_equal "<p>It is 20℃.</p>", Usertext.new("It is 20 degrees c.").to_html
    assert_equal "<p>It is 20℉.</p>", Usertext.new("It is 20 degrees f.").to_html
  end

  def test_insert_pound_symbol
    assert_equal "<p>That costs £30.</p>", Usertext.new("That costs GBP30.").to_html
  end

  def test_insert_dollar_symbol
    assert_equal "<p>That costs $30.</p>", Usertext.new("That costs USD30.").to_html
    assert_equal "<p>That costs $30.</p>", Usertext.new("That costs US30.").to_html
    assert_equal "<p>Item code PTSTUSD7201.</p>", Usertext.new("Item code PTSTUSD7201.").to_html
  end
  
  def test_insert_euro_symbol
    assert_equal "<p>That costs €30.</p>", Usertext.new("That costs EUR30.").to_html
  end

  def test_insert_yen_symbol
    assert_equal "<p>That costs ¥30.</p>", Usertext.new("That costs YEN30.").to_html
  end
  
  def test_insert_sheqel_sign_symbol
    assert_equal "<p>That costs ₪30.</p>", Usertext.new("That costs ILS30.").to_html
  end
  
  
  def test_insert_copyright_symbol
    assert_equal "<p>©Frankie Roberto</p>", Usertext.new("(c)Frankie Roberto").to_html
    assert_equal "<p>© Frankie Roberto</p>", Usertext.new("(c) Frankie Roberto").to_html
    assert_equal "<p>This text is in ©</p>", Usertext.new("This text is in (c)").to_html
  end

  
  def test_insert_suspended_hyphen
    assert_equal "<p>nineteenth‐ and twentieth‐century writers</p>", Usertext.new("nineteenth- and twentieth-century writers").to_html
  end
  
  def test_insert_hyphen
    assert_equal "<p>This is a real‐world example.</p>", Usertext.new("This is a real-world example.").to_html
  end  
  
  def test_auto_link_phone_numbers
    assert_equal "<p>Phone me on <a href=\"tel:+447736111111\">+447736111111</a></p>", Usertext.new("Phone me on +447736111111").to_html
    assert_equal "<p>Phone me on <a href=\"tel:+447736111111\">+447736111111</a>.</p>", Usertext.new("Phone me on +447736111111.").to_html
    assert_equal "<p>Phone me on <a href=\"tel:07736111111\">07736111111</a></p>", Usertext.new("Phone me on 07736111111").to_html
    assert_equal "<p>Phone me on <a href=\"tel:07736111111\">07736111111</a>.</p>", Usertext.new("Phone me on 07736111111.").to_html
  end
  
  def test_insert_numero_character
    assert_equal "<p>I live at № 4 Privet Drive</p>", Usertext.new("I live at No. 4 Privet Drive").to_html
    assert_equal "<p>Tell me your №</p>", Usertext.new("Tell me your No.").to_html
    assert_equal "<p>№ 3 is the winner!</p>", Usertext.new("No. 3 is the winner!").to_html
  end

  def test_care_of_character
    assert_equal "<p>Send it to me ℅ my company.</p>", Usertext.new("Send it to me c/o my company.").to_html
  end

  
  def test_code_tag
    assert_equal "<p>Don’t use the <code>&lt;blink&gt;</code> tag.</p>", Usertext.new("Don't use the <blink> tag.").to_html
    assert_equal "<p>4 &lt; 7 &gt; 1</p>", Usertext.new("4 < 7 > 1").to_html
  end
  
  def test_block_of_code
    assert_equal "<p>Use this code:</p>\n\n<div><code>&lt;html&gt;</code></div>",
    Usertext.new("Use this code:\n\n<html>").to_html
  end
  
  def test_mark_list
    assert_equal "<ul>\n<li>Milk</li>\n<li>Eggs</li>\n<li>Flour</li>\n</ul>", Usertext.new("* Milk\n* Eggs\n* Flour").to_html
  end
  
  def test_mark_lists
    assert_equal "<p>List:</p>\n\n<ul>\n<li>apples</li>\n<li>pears</li>\n</ul>\n\n<p>And forget milk!</p>", Usertext.new("List:\n\n* apples\n* pears\n\nAnd forget milk!").to_html
  end

  def test_mark_lists_2
    assert_equal "<p>List:</p>\n\n<ul>\n<li>apples</li>\n<li>pears</li>\n</ul>", Usertext.new("List:\n\n* apples\n* pears").to_html
  end
  
  def test_mark_ordered_list
    assert_equal "<p>Method:</p>\n\n<ol>\n<li>Stir</li>\n<li>Bake</li>\n<li>Lick spoon</li>\n</ol>", Usertext.new("Method:\n\n1. Stir\n2. Bake\n3. Lick spoon").to_html
    assert_equal "<p>Method:</p>\n\n<ol>\n<li>Stir</li>\n<li>Bake</li>\n<li>Lick spoon</li>\n</ol>", Usertext.new("Method:\n\n1) Stir\n2) Bake\n3) Lick spoon").to_html
  end
  
  def test_nothing
    assert_equal("", Usertext.new("").to_html)
  end

  def test_auto_link_ftp_url
    assert_equal "<p><a href=\"ftp://test.com\">test.com</a></p>", Usertext.new("ftp://test.com").to_html
  end
  
  def test_auto_link_url
    assert_equal "<p><a href=\"http://test.com\">test.com</a></p>", Usertext.new("http://test.com").to_html
  end

  def test_auto_link_truncated_url
    assert_equal "<p><a href=\"http://thisisareallyreallyreallyreallyreallylongurl.com\">thisisareallyreall...yreallylongurl.com</a></p>", Usertext.new("http://thisisareallyreallyreallyreallyreallylongurl.com").to_html
  end
  
  def test_one_quarter_symbol
    assert_equal "<p>I have ¼ hour left.</p>",
    Usertext.new("I have 1/4 hour left.").to_html
  end

  def test_one_half_symbol
    assert_equal "<p>I have ½ hour left.</p>",
    Usertext.new("I have 1/2 hour left.").to_html
  end
  
  def test_threw_quarters_symbol
    assert_equal "<p>I have ¾ hour left.</p>", Usertext.new("I have 3/4 hour left.").to_html
    assert_equal "<p>Give me ¾</p>", Usertext.new("Give me 3/4").to_html
    assert_equal "<p>I am on 123/4567.</p>", Usertext.new("I am on 123/4567.").to_html
  end  
  
  def test_insert_registered_trademark_symbol
    assert_equal "<p>I like LegoⓇ.</p>", Usertext.new("I like Lego(R).").to_html
    assert_equal "<p>I like LegoⓇ</p>", Usertext.new("I like Lego(R)").to_html
    assert_equal "<p>I like LegoⓇ bricks.</p>", Usertext.new("I like Lego(R) bricks.").to_html
    assert_equal "<p>x = 2(R)n</p>", Usertext.new("x = 2(R)n").to_html
  end

  
  def test_blockquote
    assert_equal "<p>She said:</p>\n\n<blockquote><p>I love you.</p></blockquote>", Usertext.new("She said:\n\n\"I love you.\"").to_html
  end


  def test_insert_roman_numerals
    assert_equal "<p>The year Ⅱ.</p>", Usertext.new("The year II.").to_html
    assert_equal "<p>Ⅱ green bottles.</p>", Usertext.new("II green bottles.").to_html
    assert_equal "<p>The year Ⅲ.</p>", Usertext.new("The year III.").to_html
    assert_equal "<p>Ⅲ green bottles.</p>", Usertext.new("III green bottles.").to_html
    assert_equal "<p>The year Ⅳ.</p>", Usertext.new("The year IV.").to_html
    assert_equal "<p>Ⅳ green bottles.</p>", Usertext.new("IV green bottles.").to_html
    assert_equal "<p>The year Ⅴ.</p>", Usertext.new("The year V.").to_html
    assert_equal "<p>Ⅴ green bottles.</p>", Usertext.new("V green bottles.").to_html
    assert_equal "<p>The year Ⅵ.</p>", Usertext.new("The year VI.").to_html
    assert_equal "<p>Ⅵ green bottles.</p>", Usertext.new("VI green bottles.").to_html
    assert_equal "<p>The year Ⅶ.</p>", Usertext.new("The year VII.").to_html
    assert_equal "<p>Ⅶ green bottles.</p>", Usertext.new("VII green bottles.").to_html
    assert_equal "<p>The year Ⅷ.</p>", Usertext.new("The year VIII.").to_html
    assert_equal "<p>Ⅷ green bottles.</p>", Usertext.new("VIII green bottles.").to_html
    assert_equal "<p>The year Ⅸ.</p>", Usertext.new("The year IX.").to_html
    assert_equal "<p>Ⅸ green bottles.</p>", Usertext.new("IX green bottles.").to_html
    assert_equal "<p>The year Ⅹ.</p>", Usertext.new("The year X.").to_html
    assert_equal "<p>Ⅹ green bottles.</p>", Usertext.new("X green bottles.").to_html
  end

  def test_insert_smiley_characters
    assert_equal "<p>Yay! ☺</p>", Usertext.new("Yay! :-)").to_html
    assert_equal "<p>Yay! ☺</p>", Usertext.new("Yay! :)").to_html    
    assert_equal "<p>No! ☹</p>", Usertext.new("No! :-(").to_html
    assert_equal "<p>No! ☹</p>", Usertext.new("No! :(").to_html    
  end


end
