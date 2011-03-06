require 'helper'

class TestUsertext < Test::Unit::TestCase

  should "test that the gem has been loaded okay" do
    
    assert_equal "", Usertext.new("").to_html
    
  end

end
