require 'test/unit'
require 'parse_user_agent'

class ParseUserAgentTest < Test::Unit::TestCase

  def setup
    # setup a list of user agent strings to test
    @user_agent_strings = [
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1',
            :browser => 'Firefox',
            :browser_version_major => '1.5',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)',
            :browser => 'MSIE',
            :browser_version_major => '6',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)',
            :browser => 'MSIE',
            :browser_version_major => '6',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.2) Gecko/20060308 Firefox/1.5.0.2 ',
            :browser => 'Firefox',
            :browser_version_major => '1.5',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1',
            :browser => 'Firefox',
            :browser_version_major => '1.5',
            :os_type => 'Macintosh',
            :os_version => 'OS X'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)',
            :browser => 'MSIE',
            :browser_version_major => '6',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/417.9 (KHTML, like Gecko) Safari/417.9.2',
            :browser => 'Safari',
            :browser_version_major => '2',
            :os_type => 'Macintosh',
            :os_version => 'OS X'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/417.9 (KHTML, like Gecko) NetNewsWire/2.0.1',
            :browser => 'NetNewsWire',
            :browser_version_major => '2',
            :os_type => 'Macintosh',
            :os_version => 'OS X'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-US) AppleWebKit/534.3 (KHTML, like Gecko) Chrome/6.0.472.63 Safari/534.3',
            :browser => 'Chrome',
            :browser_version_major => '6',
            :os_type => 'Macintosh',
            :os_version => 'OS X'
        },
        {
            :ua => 'Opera/9.80 (Macintosh; Intel Mac OS X; U; de) Presto/2.2.15 Version/10.10',
            :browser => 'Opera',
            :browser_version_major => '9',
            :os_type => 'Macintosh',
            :os_version => 'OS X'
        }
    ]
    #Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/7.0.540.0 Safari/534.10
    #Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/7.0.540.0 Safari/534.10
    # need to add others like older MSIE, Opera / Konqueror, and Linux / *BSD options, and other languages (does IE not include language?)

    @user_agents = Array.new
    @user_agent_strings.each_index do |n|
        @user_agents[n] = ParseUserAgent.new
        @user_agents[n].parse(@user_agent_strings[n][:ua])
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
    @user_agent_strings.each_index { |n| @user_agents[n].parse(@user_agent_strings[n][:ua])}
    @user_agents.each { |user_agent| assert_kind_of ParseUserAgent, user_agent}
  end

  def test_browser
    @user_agent_strings.each_index do |n|
        browser = @user_agent_strings[n][:browser]
        assert_equal browser, @user_agents[n].browser
    end
  end

  def test_browser_version_major
    @user_agent_strings.each_index do |n|
        browser_version_major = @user_agent_strings[n][:browser_version_major]
        assert_equal browser_version_major, @user_agents[n].browser_version_major
    end
  end

  def test_os_type
    @user_agent_strings.each_index do |n|
        os_type = @user_agent_strings[n][:os_type]
        assert_equal os_type, @user_agents[n].os_type
    end
  end

  def test_os_version
    @user_agent_strings.each_index do |n|
        os_version = @user_agent_strings[n][:os_version]
        assert_equal os_version, @user_agents[n].os_version
    end
  end

end
