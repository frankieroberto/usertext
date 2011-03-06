class Usertext


  def initialize(text)
    @string = text
  end
  
  def to_html
    html = @string

    html = html.to_s
    html = cleanup_newlines(html)
    
    # Character level markup
    html = replace_typography(html)
    html = insert_currency_symbols(html)
    html = insert_fraction_symbols(html)
    html = insert_roman_numerals(html)
    html = insert_smileys(html)
    html = insert_copyright_symbols(html)
    
    # Block level markup
    html = html_escape(html)
    html = mark_code(html)
    html = auto_link(html)
    html = auto_link_phone_numbers(html)
    html = block_element_markup(html)

    return html
  end
  
  private
  
    def block_element_markup(text)
      new_text = Array.new
      li_re     = /^\*\s(.*)$/
      ol_re     = /^\d+[\.\)]\s(.*)$/ 
      quote_re  = /^“(.*)”$/
      code_re   = /^<code>.*<\/code>$/ 
      text.split("\n\n").map do |block|
        case block
        when li_re
          lines = block.gsub(li_re, '<li>\1</li>')
          content_tag("ul", "\n" + lines + "\n")
        when ol_re
          lines = block.gsub(ol_re, '<li>\1</li>')
          content_tag("ol", "\n" + lines + "\n")
        when quote_re
          content_tag("blockquote", content_tag("p", block.gsub(quote_re, '\1')))
        when code_re
          content_tag("div", block)
        else        
          content_tag("p", block)
        end
      end .join("\n\n")
    
    end
    
    def replace_typography(string)
      string.
      gsub(/\'(\d\ds)/, '’\1').             # replacing '30s with ’30s
      gsub(/(\d+)'(\s)/, '\1′\2').          # replacing ' with single prime
      gsub(/(\d+)"(\s)/, '\1″\2').          # replacing " with double prime
      gsub(/(\d+)'''(\s)/, '\1‴\2').          # replacing ''' with triple prime
      gsub(/(\d+)""(\s)/, '\1⁗\2').          # replacing "" with quadruple prime
      gsub(/([^\s]+)\'(\s)/, '\1’\2').      # replacing ' with ’ (right single quote)
      gsub(/(\s)\'([^\s])/, '\1‘\2').       # replacing ' with ‘ (left single quote)
      gsub(/([^\s]+)\"/, '\1”').            # replacing " with ” (right double quote)
      gsub(/\"([a-zA-Z])/, '“\1').             # replacing " with “ (left double quote)
      gsub(/([^\s])\'([^\s])/, '\1’\2').    # replacing ' with ’ (apostrophe)
    #   gsub(/(\s)\"(\s)/, '\1&#12291;\2').   # replacing " with 〃 (ditto mark)
      gsub(/(\d+)x(\d+)/, '\1×\2').         # replacing x with multiplication char
      gsub(/(\d{3,})-(\d{3,})/, '\1‒\2').           # replacing dash with figure dash
      gsub(/(\d)-(\d)/, '\1–\2').           # replacing hypen-dash with en dash (for ranges)
      gsub(/([A-Za-z\d])--([A-Za-z\d])/, '\1—\2').   # replacing double hypen-dash with em dash (parenthetical thought)
      gsub(/([a-zA-Z])-([\sa-zA-Z])/, '\1‐\2'). # replacing hyphen-dash with hyphen char
      gsub(/([\d])-([\d])/, '\1–\2').       # replacing - with en-dash
      gsub(/([^\.])\.\.\.([^\.]|$)/, '\1…\2').# replacing ... with elipsis
      gsub(/(\d) degrees c/, '\1℃').  # inserting typographic degrees character
      gsub(/(\d) degrees f/, '\1℉').  # inserting typographic degrees character
      gsub(/(\d) degrees (f)/, '\1°\2').  # inserting typographic degrees character
      gsub(/(\s|^)No.(\s\d|$)/, '\1№\2').     # replace No. 3 with № 3   
      gsub(/(\s|\A)c\/o(\s|$)/, '\1℅\2').     # replace c/o with ℅
      gsub(/(\s|\A)a\/c(\s[A-Z]|$)/, '\1℀\2').     # replace a/c with ℀


      to_s
    end    


    def insert_fraction_symbols(text)
      text.
      gsub(/(\s|^)1\/4(\s|$)/, '\1¼\2').     # replacing 1/4 with ¼
      gsub(/(\s|^)1\/2(\s|$)/, '\1½\2').     # replacing 1/2 with ½
      gsub(/(\s|^)3\/4(\s|$)/, '\1¾\2').     # replacing 3/4 with ¾      
      gsub(/(\s|^)1\/3(\s|$)/, '\1⅓\2').     # replacing 1/3 with ⅓
      gsub(/(\s|^)2\/3(\s|$)/, '\1⅔\2').     # replacing 2/3 with ⅔
      gsub(/(\s|^)1\/5(\s|$)/, '\1⅕\2').     # replacing 1/5 with ⅕
      gsub(/(\s|^)2\/5(\s|$)/, '\1⅖\2').     # replacing 2/5 with ⅖
      gsub(/(\s|^)4\/5(\s|$)/, '\1⅖\2').     # replacing 4/5 with ⅘
      gsub(/(\s|^)1\/6(\s|$)/, '\1⅙\2').     # replacing 1/6 with ⅙
      gsub(/(\s|^)5\/6(\s|$)/, '\1⅖\2').     # replacing 5/6 with ⅚      
      gsub(/(\s|^)1\/8(\s|$)/, '\1⅛\2').     # replacing 1/8 with ⅛           
      gsub(/(\s|^)3\/8(\s|$)/, '\1⅜\2').     # replacing 3/8 with ⅜           
      gsub(/(\s|^)5\/8(\s|$)/, '\1⅝\2').     # replacing 5/8 with ⅝           
      gsub(/(\s|^)7\/8(\s|$)/, '\1⅞\2').     # replacing 7/8 with ⅞                     
      to_s
    end

    def insert_currency_symbols(text)
      text.
      gsub(/(\s|^)GBP(\d+)/, '\1£\2').              # inserting Pound sign.
      gsub(/(\s|^)USD?(\d+)/, '\1$\2').              # inserting Dollar sign.
      gsub(/(\s|^)EUR(\d+)/, '\1€\2').              # inserting Euro sign.
      gsub(/(\s|^)YEN(\d+)/, '\1¥\2').              # inserting Yen sign.
      gsub(/(\s|^)ILS(\d+)/, '\1₪\2').              # inserting Israeli shekel symbol.
      gsub(/(\s|^)GEL(\d+)/, '\1ლ\2').              # inserting Georgian lari symbol.
      gsub(/(\s|^)AFN(\d+)/, '\1؋\2').              # inserting Afghan afghani symbol.
      gsub(/(\s|^)ALL(\d+)/, '\1L\2').              # inserting Albanian lek symbol.
      gsub(/(\s|^)DZD(\d+)/, '\1د.ج\2').              # inserting Algerian dinar symbol.
      gsub(/(\s|^)PHP(\d+)/, '\1₱\2').              # inserting Philippine peso symbol.
      gsub(/(\s|^)UAH(\d+)/, '\1₴\2').              # inserting Ukrainian hryvnia symbol.
      to_s

    end  

    def cleanup_newlines(text)
      text.gsub(/\r\n?/, "\n")                    # \r\n and \r -> \n
    end

    def auto_link_phone_numbers(text)
      text.gsub(/(\s|^)((0|\+44)\d{10,10})\b/) do 
        text = $1 + "<a href=\"tel:" + $2 + "\">" + $2 + "</a>"
      end
    end    
    
    def mark_code(text)
      text.
      gsub(/(^&lt;[a-zA-Z]+.*$|&lt;[a-zA-Z]+.*&gt;)/) do 
        "<code>" + $1 + "</code>"
      end
    end

    def auto_link(text)
      auto_link_urls(text)
    end

    def auto_link_urls(text)

      auto_link_re = %r{
       (                          # leading text
         <\w+.*?>|                # leading HTML tag, or
         [^=!:'"/]|               # leading punctuation, or 
         ^                        # beginning of line
       )
       (https?://|ftp://)              # protocol spec

       (
         [-\w]+                   # subdomain or domain
         (?:\.[-\w]+)*            # remaining subdomains or domain
         (?::\d+)?                # port
         (?:/(?:(?:[~\w\+@%-]|(?:[,.;:][^\s$]))+)?)* # path
         (?:\?[\w\+@%&=.;-]+)?     # query string
         (?:\#[\w\-\/]*)?           # trailing anchor
       )(([[:punct:]]|\s|<|$))       # trailing text
      }x

      text.gsub(auto_link_re) do
        all, a, b, c, d = $&, $1, $2, $3, $5

        text = a + "<a href=\"" + b + c + "\">" + truncate_in_middle(c, 40) + "</a>" + $5
      end
    end

    # This helper is like the trunctate() method included in Rails core, but truncates
    # in the middle of the string rather than at the end. This is useful for things like
    # URLs, which it is sometimes helpful to show the beginning and the end.
    def truncate_in_middle(text, length = 30, truncate_string = "...")
      if text
        l = (length - truncate_string.length) / 2
        return text if length > text.length
        return text[0...l] + truncate_string + text[-l..-1]
      end
    end      

    def insert_roman_numerals(text)
      text.
      gsub(/(\s|^)II([\s\.]|$)/, '\1Ⅱ\2').       # Replace II with Ⅱ (roman numeral)
      gsub(/(\s|^)III([\s\.]|$)/, '\1Ⅲ\2').      # Replace III with Ⅲ (roman numeral)
      gsub(/(\s|^)IV([\s\.]|$)/, '\1Ⅳ\2').      # Replace IV with Ⅳ (roman numeral)
      gsub(/(\s|^)V([\s\.]|$)/, '\1Ⅴ\2').      # Replace V with Ⅴ (roman numeral)
      gsub(/(\s|^)VI([\s\.]|$)/, '\1Ⅵ\2').      # Replace VI with Ⅵ (roman numeral)
      gsub(/(\s|^)VII([\s\.]|$)/, '\1Ⅶ\2').      # Replace VII with Ⅶ (roman numeral)
      gsub(/(\s|^)VIII([\s\.]|$)/, '\1Ⅷ\2').      # Replace VIII with Ⅷ (roman numeral)
      gsub(/(\s|^)IX([\s\.]|$)/, '\1Ⅸ\2').      # Replace IX with Ⅸ (roman numeral)
      gsub(/(\s|^)X([\s\.]|$)/, '\1Ⅹ\2').      # Replace X with Ⅹ (roman numeral)
      to_s
    end

    def insert_smileys(text)
      text.
      gsub(/(\s|^):-?\)(\s|$)/, '\1☺\2').       # Replace :-) or :) with ☺
      gsub(/(\s|^):-?\((\s|$)/, '\1☹\2').       # Replace :-( or :( with ☹
      to_s    
    end  

    def insert_copyright_symbols(text)
      text.
      gsub(/\(R\)([\W]|$)/, 'Ⓡ\1').     # inserting Registered trademark sign.        
      gsub(/\(c\)([\sA-Za-z]|$)/, '©\1').     # inserting Copyright sign.
      to_s
    end    
    
    def content_tag(tagname, contents, options = {})      
      "<" + tagname + ">" + contents + "</" + tagname + ">"
    end
    
    def html_escape(s)
      s.to_s.gsub(/&/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;")
    end
    
  
end