require 'test/unit'
require 'parse_user_agent'

class ParseUserAgentTest < Test::Unit::TestCase

  def setup
    # setup a list of user agent strings to test
    @user_agent_strings = [
        'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1',
        'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)',
        'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)',
        'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.2) Gecko/20060308 Firefox/1.5.0.2 ',
        'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1',
        'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)',
        'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/417.9 (KHTML, like Gecko) Safari/417.9.2',
        'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/417.9 (KHTML, like Gecko) NetNewsWire/2.0.1',
        'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-US) AppleWebKit/534.3 (KHTML, like Gecko) Chrome/6.0.472.63 Safari/534.3',
        'Opera/9.80 (Macintosh; Intel Mac OS X; U; de) Presto/2.2.15 Version/10.10'
    ]
    #Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/7.0.540.0 Safari/534.10
    #Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/7.0.540.0 Safari/534.10
    # need to add others like older MSIE, Opera / Konqueror, and Linux / *BSD options, and other languages (does IE not include language?)

    @user_agents = Array.new
    @user_agent_strings.each_index do |n|
        @user_agents[n] = ParseUserAgent.new
        @user_agents[n].parse(@user_agent_strings[n])
    end
  end

  # this should throw a better exception
  def test_invalid
    assert_raise(RuntimeError) { ParseUserAgent.new.parse('-')}
    # need to test blank user agent strings as well
  end

  # test using new to create
  def test_create
    @user_agents.each { |user_agent| assert_kind_of ParseUserAgent, user_agent}
  end
  
  # this test sucks because I had to parse during setup
  def test_parse
    @user_agent_strings.each_index { |n| @user_agents[n].parse(@user_agent_strings[n])}
    @user_agents.each { |user_agent| assert_kind_of ParseUserAgent, user_agent}
  end

  def test_browser
    assert_equal 'Firefox', @user_agents[0].browser
    assert_equal 'MSIE', @user_agents[1].browser
    assert_equal 'MSIE', @user_agents[2].browser
    assert_equal 'Firefox', @user_agents[3].browser
    assert_equal 'Firefox', @user_agents[4].browser
    assert_equal 'MSIE', @user_agents[5].browser
    assert_equal 'Safari', @user_agents[6].browser
    assert_equal 'NetNewsWire', @user_agents[7].browser
    assert_equal 'Chrome', @user_agents[8].browser
    assert_equal 'Opera', @user_agents[9].browser
    # add additional tests when more test strings are available
  end

  def test_browser_version_major
    assert_equal '1.5',@user_agents[0].browser_version_major
    assert_equal '6',@user_agents[1].browser_version_major
    assert_equal '6',@user_agents[2].browser_version_major
    assert_equal '1.5', @user_agents[3].browser_version_major
    assert_equal '1.5', @user_agents[4].browser_version_major
    assert_equal '6', @user_agents[5].browser_version_major
    assert_equal '2', @user_agents[6].browser_version_major
    assert_equal '2', @user_agents[7].browser_version_major
    assert_equal '6', @user_agents[8].browser_version_major
    assert_equal '9', @user_agents[9].browser_version_major
  end

  def test_os_type
    assert_equal 'Windows', @user_agents[0].os_type
    assert_equal 'Windows', @user_agents[1].os_type
    assert_equal 'Windows', @user_agents[2].os_type
    assert_equal 'Windows', @user_agents[3].os_type
    assert_equal 'Macintosh', @user_agents[4].os_type
    assert_equal 'Windows', @user_agents[5].os_type
    assert_equal 'Macintosh', @user_agents[6].os_type
    assert_equal 'Macintosh', @user_agents[7].os_type
    assert_equal 'Macintosh', @user_agents[8].os_type
    assert_equal 'Macintosh', @user_agents[9].os_type
  end

  def test_os_version
    assert_equal 'XP', @user_agents[0].os_version
    assert_equal 'XP', @user_agents[1].os_version
    assert_equal 'XP', @user_agents[2].os_version
    assert_equal 'XP', @user_agents[3].os_version
    assert_equal 'OS X', @user_agents[4].os_version
    assert_equal 'XP', @user_agents[5].os_version
    assert_equal 'OS X', @user_agents[6].os_version
    assert_equal 'OS X', @user_agents[7].os_version
    assert_equal 'OS X', @user_agents[8].os_version
    assert_equal 'OS X', @user_agents[9].os_version
  end

end
