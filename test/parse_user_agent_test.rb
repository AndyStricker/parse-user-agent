require 'test/unit'
require 'parse_user_agent'

class ParseUserAgentTest < Test::Unit::TestCase

  def setup
    # setup a list of user agent strings to test
    @user_agent_strings = [
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1',
            :browser => 'Firefox',
            :browser_version_major => '1',
            :browser_version_minor => '5',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)',
            :browser => 'MSIE',
            :browser_version_major => '6',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)',
            :browser => 'MSIE',
            :browser_version_major => '6',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/5.0 (compatible; MSIE 10.0; Windows Phone 8.0; Trident/6.0; ARM; Touch; IEMobile/10.0; AManufacturer; SomeDevice; MaybeAnOperator)',
            :browser => 'MSIE',
            :browser_version_major => '10',
            :browser_version_minor => '0',
            :os_type => 'Windows Phone',
            :os_version => '8.0'
        },
        {
            :ua => 'Mozilla/5.0 (IE 11.0; Windows NT 6.3; Trident/7.0; .NET4.0E; .NET4.0C; rv:11.0) like Gecko',
            :browser => 'MSIE',
            :browser_version_major => '11',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'NT 6.3'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.2) Gecko/20060308 Firefox/1.5.0.2 ',
            :browser => 'Firefox',
            :browser_version_major => '1',
            :browser_version_minor => '5',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1',
            :browser => 'Firefox',
            :browser_version_major => '1',
            :browser_version_minor => '5',
            :os_type => 'Macintosh',
            :os_version => 'OS X'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)',
            :browser => 'MSIE',
            :browser_version_major => '6',
            :browser_version_minor => '0',
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
            :browser_version_minor => '0',
            :os_type => 'Macintosh',
            :os_version => 'OS X 10.6'
        },
        {
            :ua => 'Opera/9.80 (Macintosh; Intel Mac OS X; U; de) Presto/2.2.15 Version/10.10',
            :browser => 'Opera',
            :browser_version_major => '9',
            :browser_version_minor => '80',
            :os_type => 'Macintosh',
            :os_version => 'OS X'
        },
        {
            :ua => 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/535.1 (KHTML, like Gecko) Ubuntu/11.04 Chromium/14.0.825.0 Chrome/14.0.825.0 Safari/535.1',
            :browser => 'Chrome',
            :browser_version_major => '14',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 ArchLinux (X11; Linux x86_64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.41 Safari/535.1',
            :browser => 'Chrome',
            :browser_version_major => '13',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (Windows NT 6.1; en-US) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.750.0 Safari/534.30',
            :browser => 'Chrome',
            :browser_version_major => '12',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (X11; CrOS i686 12.433.109) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.93 Safari/534.30',
            :browser => 'Chrome',
            :browser_version_major => '12',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => 'Chrome OS'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/7.0.540.0 Safari/534.10',
            :browser => 'Chrome',
            :browser_version_major => '7',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/7.0.540.0 Safari/534.10',
            :browser => 'Chrome',
            :browser_version_major => '7',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'XP 64/Server 2003'
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/534.7 (KHTML, like Gecko) Chrome/7.0.517.24 Safari/534.7',
            :browser => 'Chrome',
            :browser_version_major => '7',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/533.2 (KHTML, like Gecko) Chrome/6.0',
            :browser => 'Chrome',
            :browser_version_major => '6',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/533.4 (KHTML, like Gecko) Chrome/5.0.375.999 Safari/533.4',
            :browser => 'Chrome',
            :browser_version_major => '5',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/532.5 (KHTML, like Gecko) Chrome/4.1.249.1025 Safari/532.5',
            :browser => 'Chrome',
            :browser_version_major => '4',
            :browser_version_minor => '1',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_8; en-US) AppleWebKit/532.8 (KHTML, like Gecko) Chrome/4.0.302.2 Safari/532.8',
            :browser => 'Chrome',
            :browser_version_major => '4',
            :browser_version_minor => '0',
            :os_type => 'Macintosh',
            :os_version => 'OS X 10.5'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_8; en-US) AppleWebKit/532.0 (KHTML, like Gecko) Chrome/3.0.198 Safari/532.0',
            :browser => 'Chrome',
            :browser_version_major => '3',
            :browser_version_minor => '0',
            :os_type => 'Macintosh',
            :os_version => 'OS X 10.5'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17',
            :browser => 'Chrome',
            :browser_version_major => '24',
            :browser_version_minor => '0',
            :os_type => 'Macintosh',
            :os_version => 'OS X 10.8'
        },
        {
            :ua => 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; chromeframe/12.0.742.112)',
            :browser => 'MSIE',
            :browser_version_major => '9',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/5.0)',
            :browser => 'MSIE',
            :browser_version_major => '10',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0; .NET CLR 2.0.50727; SLCC2; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; Zune 4.0; Tablet PC 2.0; InfoPath.3; .NET4.0C; .NET4.0E)',
            :browser => 'MSIE',
            :browser_version_major => '9',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; MSIE 9.0; Windows NT 6.1; en-US)',
            :browser => 'MSIE',
            :browser_version_major => '9',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; Media Center PC 6.0; InfoPath.3; MS-RTC LM 8; Zune 4.7)',
            :browser => 'MSIE',
            :browser_version_major => '9',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 2.0.50727; Media Center PC 6.0)',
            :browser => 'MSIE',
            :browser_version_major => '9',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET4.0C; .NET4.0E; FDM)',
            :browser => 'MSIE',
            :browser_version_major => '8',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; eSobiSubscriber 2.0.4.16; OfficeLiveConnector.1.4; OfficeLivePatch.1.3; InfoPath.3)',
            :browser => 'MSIE',
            :browser_version_major => '8',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; SLCC1; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 1.1.4322; Tablet PC 2.0; InfoPath.2; MS-RTC LM 8)',
            :browser => 'MSIE',
            :browser_version_major => '8',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'Vista/Server 2008'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; MS-RTC LM 8)',
            :browser => 'MSIE',
            :browser_version_major => '8',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'Vista/Server 2008'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; WOW64; SLCC1; .NET CLR 2.0.50727; .NET CLR 3.0.04506; Media Center PC 5.0; .NET CLR 1.1.4322)',
            :browser => 'MSIE',
            :browser_version_major => '8',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'Vista/Server 2008'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)',
            :browser => 'MSIE',
            :browser_version_major => '7',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)',
            :browser => 'MSIE',
            :browser_version_major => '7',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Trident/4.0; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.5.21022; .NET CLR 3.0.30618; .NET CLR 3.5.30729)',
            :browser => 'MSIE',
            :browser_version_major => '7',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'Vista/Server 2008'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; AT&T CSM8.1; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; .NET CLR 1.0.3705; .NET CLR 1.1.4322; Media Center PC 4.0; InfoPath.1; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)',
            :browser => 'MSIE',
            :browser_version_major => '6',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; FunWebProducts; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.0.04506; Windows-Media-Player/10.00.00.3990)',
            :browser => 'MSIE',
            :browser_version_major => '7',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'Vista/Server 2008'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows 98; Win 9x 4.90; Creative)',
            :browser => 'MSIE',
            :browser_version_major => '6',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '98'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; America Online Browser 1.1; rev1.2; Windows NT 5.1; SV1; .NET CLR 1.1.4322)',
            :browser => 'MSIE',
            :browser_version_major => '6',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Update a; AOL 6.0; Windows 98)',
            :browser => 'MSIE',
            :browser_version_major => '6',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '98'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT) ::ELNSB50::000061100320025802a00111000000000507000900000000',
            :browser => 'MSIE',
            :browser_version_major => '6',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'NT'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 5.23; Macintosh; PPC) Escape 5.1.3',
            :browser => 'MSIE',
            :browser_version_major => '5',
            :browser_version_minor => '23',
            :os_type => 'Macintosh',
            :os_version => 'MacOS'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 5.23; Mac_PowerPC)',
            :browser => 'MSIE',
            :browser_version_major => '5',
            :browser_version_minor => '23',
            :os_type => 'Macintosh',
            :os_version => 'MacOS'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.0; .NET CLR 1.1.4322)',
            :browser => 'MSIE',
            :browser_version_major => '5',
            :browser_version_minor => '5',
            :os_type => 'Windows',
            :os_version => '2000'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 5.5; Windows 95)',
            :browser => 'MSIE',
            :browser_version_major => '5',
            :browser_version_minor => '5',
            :os_type => 'Windows',
            :os_version => '95'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 5.13; Mac_PowerPC)',
            :browser => 'MSIE',
            :browser_version_major => '5',
            :browser_version_minor => '13',
            :os_type => 'Macintosh',
            :os_version => 'MacOS'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 5.5; Windows 95; BCD2000)',
            :browser => 'MSIE',
            :browser_version_major => '5',
            :browser_version_minor => '5',
            :os_type => 'Windows',
            :os_version => '95'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 5.0; SunOS 5.10 sun4u; X11)',
            :browser => 'MSIE',
            :browser_version_major => '5',
            :browser_version_minor => '0',
            :os_type => 'SunOS',
            :os_version => '5.10 sun4u'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 6.1; it; rv:2.0b4) Gecko/20100818',
            :browser => 'Mozilla',
            :browser_version_major => '2',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a3pre) Gecko/20070330',
            :browser => 'Mozilla',
            :browser_version_major => '1',
            :browser_version_minor => '9',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.1b3) Gecko/20090305',
            :browser => 'Mozilla',
            :browser_version_major => '1',
            :browser_version_minor => '9',
            :os_type => 'Windows',
            :os_version => 'Vista/Server 2008'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.8.1.12) Gecko/20080201',
            :browser => 'Mozilla',
            :browser_version_major => '1',
            :browser_version_minor => '8',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.1) Gecko/20061204',
            :browser => 'Mozilla',
            :browser_version_major => '1',
            :browser_version_minor => '8',
            :os_type => 'Macintosh',
            :os_version => 'OS X'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; fr; rv:1.7.8) Gecko/20050511',
            :browser => 'Mozilla',
            :browser_version_major => '1',
            :browser_version_minor => '7',
            :os_type => 'Windows',
            :os_version => '2000'
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.3) Gecko/20030318',
            :browser => 'Mozilla',
            :browser_version_major => '1',
            :browser_version_minor => '3',
            :os_type => 'SunOS',
            :os_version => 'sun4u'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; WinNT4.0; en-US; rv:1.3) Gecko/20030312',
            :browser => 'Mozilla',
            :browser_version_major => '1',
            :browser_version_minor => '3',
            :os_type => 'Windows',
            :os_version => 'NT 4.0'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Win98; en-US; rv:1.3) Gecko/20030312',
            :browser => 'Mozilla',
            :browser_version_major => '1',
            :browser_version_minor => '3',
            :os_type => 'Windows',
            :os_version => '98'
        },
        {
            :ua => 'Mozilla/5.0 (X11; Linux x86_64; rv:2.0b4) Gecko/20100818 Firefox/4.0b4',
            :browser => 'Firefox',
            :browser_version_major => '4',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; Linux i686; ru; rv:1.9.3a5pre) Gecko/20100526 Firefox/3.7a5pre',
            :browser => 'Firefox',
            :browser_version_major => '3',
            :browser_version_minor => '7',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2b5) Gecko/20091204 Firefox/3.6b5',
            :browser => 'Firefox',
            :browser_version_major => '3',
            :browser_version_minor => '6',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; fa; rv:1.9.1.7) Gecko/20091221 Firefox/3.5.7',
            :browser => 'Firefox',
            :browser_version_major => '3',
            :browser_version_minor => '5',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 6.0; es-AR; rv:1.9.1b3) Gecko/20090305 Firefox/3.1b3',
            :browser => 'Firefox',
            :browser_version_major => '3',
            :browser_version_minor => '1',
            :os_type => 'Windows',
            :os_version => 'Vista/Server 2008'
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; Slackware Linux i686; en-US; rv:1.9.0.10) Gecko/2009042315 Firefox/3.0.10',
            :browser => 'Firefox',
            :browser_version_major => '3',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; OpenBSD amd64; en-US; rv:1.9.0.1) Gecko/2008081402 Firefox/3.0.1',
            :browser => 'Firefox',
            :browser_version_major => '3',
            :browser_version_minor => '0',
            :os_type => 'OpenBSD',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/6.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:2.0.0.0) Gecko/20061028 Firefox/3.0',
            :browser => 'Firefox',
            :browser_version_major => '3',
            :browser_version_minor => '0',
            :os_type => 'Macintosh',
            :os_version => 'OS X'
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; SunOS sun4v; es-ES; rv:1.8.1.9) Gecko/20071127 Firefox/2.0.0.9',
            :browser => 'Firefox',
            :browser_version_major => '2',
            :browser_version_minor => '0',
            :os_type => 'SunOS',
            :os_version => 'sun4v'
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.8.1.9) Gecko/20071102 Firefox/2.0.0.9',
            :browser => 'Firefox',
            :browser_version_major => '2',
            :browser_version_minor => '0',
            :os_type => 'SunOS',
            :os_version => 'sun4u'
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; x86_64 Linux; en_US; rv:1.8.16) Gecko/20071015 Firefox/2.0.0.8',
            :browser => 'Firefox',
            :browser_version_major => '2',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; NetBSD sparc64; fr-FR; rv:1.8.1.6) Gecko/20070822 Firefox/2.0.0.6',
            :browser => 'Firefox',
            :browser_version_major => '2',
            :browser_version_minor => '0',
            :os_type => 'NetBSD',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; NetBSD alpha; en-US; rv:1.8.1.6) Gecko/20080115 Firefox/2.0.0.6',
            :browser => 'Firefox',
            :browser_version_major => '2',
            :browser_version_minor => '0',
            :os_type => 'NetBSD',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; SunOS i86pc; en-ZW; rv:1.8.1.6) Gecko/20071125 Firefox/2.0.0.6',
            :browser => 'Firefox',
            :browser_version_major => '2',
            :browser_version_minor => '0',
            :os_type => 'SunOS',
            :os_version => 'i86pc'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; ; rv:1.8.0.1) Gecko/20060111 Firefox/1.9.0',
            :browser => 'Firefox',
            :browser_version_major => '1',
            :browser_version_minor => '9',
            :os_type => 'Windows',
            :os_version => '2000'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 5.2 x64; en-US; rv:1.9a1) Gecko/20060214 Firefox/1.6a1',
            :browser => 'Firefox',
            :browser_version_major => '1',
            :browser_version_minor => '6',
            :os_type => 'Windows',
            :os_version => 'XP 64/Server 2003'
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; FreeBSD i386; en-US; rv:1.8.0.8) Gecko/20061210 Firefox/1.5.0.8',
            :browser => 'Firefox',
            :browser_version_major => '1',
            :browser_version_minor => '5',
            :os_type => 'FreeBSD',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; FreeBSD amd64; en-US; rv:1.8.0.8) Gecko/20061116 Firefox/1.5.0.8',
            :browser => 'Firefox',
            :browser_version_major => '1',
            :browser_version_minor => '5',
            :os_type => 'FreeBSD',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; es-ES; rv:1.8.0.3) Gecko/20060426 Firefox/1.5.0.3',
            :browser => 'Firefox',
            :browser_version_major => '1',
            :browser_version_minor => '5',
            :os_type => 'Macintosh',
            :os_version => 'OS X'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Win 9x 4.90; en-US; rv:1.8.0.3) Gecko/20060426 Firefox/1.5.0.3',
            :browser => 'Firefox',
            :browser_version_major => '1',
            :browser_version_minor => '5',
            :os_type => 'Windows',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8b4) Gecko/20050908 Firefox/1.4',
            :browser => 'Firefox',
            :browser_version_major => '1',
            :browser_version_minor => '4',
            :os_type => 'Windows',
            :os_version => '2000'
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060413 Red Hat/1.0.8-1.4.1 Firefox/1.0.8',
            :browser => 'Firefox',
            :browser_version_major => '1',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; Linux i686; pt-PT; rv:1.9.2.3) Gecko/20100402 Iceweasel/3.6.3 (like Firefox/3.6.3) GTB7.0',
            :browser => 'Firefox',
            :browser_version_major => '3',
            :browser_version_minor => '6',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.2) Gecko/2008090211 Ubuntu/9.04 (jaunty) Iceweasel/3.0.2',
            :browser => 'Firefox',
            :browser_version_major => '3',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; Linux x86_64; es-AR; rv:1.9.0.2) Gecko/2008091920 Firefox/3.0.2 Flock/2.0b3',
            :browser => 'Firefox',
            :browser_version_major => '3',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (Windows NT 6.1; rv:1.9) Gecko/20100101 Firefox/4.0',
            :browser => 'Firefox',
            :browser_version_major => '4',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (X11; Linux x86_64; rv:2.0.1) Gecko/20110506 Firefox/4.0.1',
            :browser => 'Firefox',
            :browser_version_major => '4',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:5.0.1) Gecko/20100101 Firefox/5.0.1',
            :browser => 'Firefox',
            :browser_version_major => '5',
            :browser_version_minor => '0',
            :os_type => 'Macintosh',
            :os_version => 'OS X 10.6'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:5.0) Gecko/20100101 Firefox/5.0',
            :browser => 'Firefox',
            :browser_version_major => '5',
            :browser_version_minor => '0',
            :os_type => 'Macintosh',
            :os_version => 'OS X 10.7'
        },
        {
            :ua => 'Mozilla/5.0 (Windows NT 6.1; U; ru; rv:5.0.1.6) Gecko/20110501 Firefox/5.0.1 Firefox/5.0.1',
            :browser => 'Firefox',
            :browser_version_major => '5',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0a2) Gecko/20110613 Firefox/6.0a2',
            :browser => 'Firefox',
            :browser_version_major => '6',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Mozilla/6.0 (Windows NT 6.2; WOW64; rv:16.0.1) Gecko/20121011 Firefox/16.0.1',
            :browser => 'Firefox',
            :browser_version_major => '16',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => '8'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50',
            :browser => 'Safari',
            :browser_version_major => '5',
            :browser_version_minor => '1',
            :os_type => 'Macintosh',
            :os_version => 'OS X 10.6'
        },
        {
            :ua => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_1 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8B5097d Safari/6531.22.7',
            :browser => 'Safari',
            :browser_version_major => '4',
            :browser_version_minor => '0',
            :os_type => 'iOS',
            :os_version => 'iPhone iOS 4.1'
        },
        {
            :ua => 'Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; ja-jp) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5',
            :browser => 'Safari',
            :browser_version_major => '5',
            :browser_version_minor => '0',
            :os_type => 'iOS',
            :os_version => 'iPod iOS 4.3'
        },
        {
            :ua => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3 like Mac OS X; pl-pl) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8F190 Safari/6533.18.5',
            :browser => 'Safari',
            :browser_version_major => '5',
            :browser_version_minor => '0',
            :os_type => 'iOS',
            :os_version => 'iPhone iOS 4.3'
        },
        {
            :ua => 'Mozilla/5.0(iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10gin_lib.cc',
            :browser => 'Safari',
            :browser_version_major => '4',
            :browser_version_minor => '0',
            :os_type => 'iOS',
            :os_version => 'iPad iOS 3.2'
        },
        {
            :ua => 'Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3',
            :browser => 'Safari',
            :browser_version_major => '3',
            :browser_version_minor => '0',
            :os_type => 'iOS',
            :os_version => 'iPhone'
        },
        {
            :ua => 'Opera/9.64 (Windows NT 6.1; U; de) Presto/2.1.1',
            :browser => 'Opera',
            :browser_version_major => '9',
            :browser_version_minor => '64',
            :os_type => 'Windows',
            :os_version => '7/Server 2008 R2'
        },
        {
            :ua => 'Opera/9.02 (Windows NT 5.1; U; en)',
            :browser => 'Opera',
            :browser_version_major => '9',
            :browser_version_minor => '02',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) Opera 8.65 [en]',
            :browser => 'Opera',
            :browser_version_major => '8',
            :browser_version_minor => '65',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows CE; Sprint:PPC-6700) Opera 8.65 [en]',
            :browser => 'Opera',
            :browser_version_major => '8',
            :browser_version_minor => '65',
            :os_type => 'Windows',
            :os_version => 'CE'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows CE; PPC; 240x240) Opera 8.60 [en]',
            :browser => 'Opera',
            :browser_version_major => '8',
            :browser_version_minor => '60',
            :os_type => 'Windows',
            :os_version => 'CE'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows 98; en) Opera 8.54',
            :browser => 'Opera',
            :browser_version_major => '8',
            :browser_version_minor => '54',
            :os_type => 'Windows',
            :os_version => '98'
        },
        {
            :ua => 'Opera/8.51 (FreeBSD 5.1; U; en)',
            :browser => 'Opera',
            :browser_version_major => '8',
            :browser_version_minor => '51',
            :os_type => 'FreeBSD',
            :os_version => nil
        },
        {
            :ua => 'Opera/8.50 (Windows ME; U; en)',
            :browser => 'Opera',
            :browser_version_major => '8',
            :browser_version_minor => '50',
            :os_type => 'Windows',
            :os_version => 'ME'
        },
        {
            :ua => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows CE) Opera 8.0 [en]',
            :browser => 'Opera',
            :browser_version_major => '8',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'CE'
        },
        {
            :ua => 'Opera/7.51 (X11; SunOS sun4u; U) [de]',
            :browser => 'Opera',
            :browser_version_major => '7',
            :browser_version_minor => '51',
            :os_type => 'SunOS',
            :os_version => 'sun4u'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; de-de) AppleWebKit/533.18.1 (KHTML, like Gecko) Version/5.0.2 Safari/533.18.5',
            :browser => 'Safari',
            :browser_version_major => '5',
            :browser_version_minor => '0',
            :os_type => 'Macintosh',
            :os_version => 'OS X 10.6'
        },
        {
            :ua => 'Mozilla/5.0 (X11; U; Linux x86_64; en-ca) AppleWebKit/531.2+ (KHTML, like Gecko) Version/5.0 Safari/531.2+',
            :browser => 'Safari',
            :browser_version_major => '5',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => nil
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_4_11; ja-jp) AppleWebKit/533.16 (KHTML, like Gecko) Version/4.1 Safari/533.16',
            :browser => 'Safari',
            :browser_version_major => '4',
            :browser_version_minor => '1',
            :os_type => 'Macintosh',
            :os_version => 'OS X 10.4'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_6; en-gb) AppleWebKit/528.10+ (KHTML, like Gecko) Version/4.0dp1 Safari/526.11.2',
            :browser => 'Safari',
            :browser_version_major => '4',
            :browser_version_minor => '0',
            :os_type => 'Macintosh',
            :os_version => 'OS X 10.5'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_7; en-us) AppleWebKit/531.2+ (KHTML, like Gecko) Version/4.0.1 Safari/530.18',
            :browser => 'Safari',
            :browser_version_major => '4',
            :browser_version_minor => '0',
            :os_type => 'Macintosh',
            :os_version => 'OS X 10.5'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; nb-NO) AppleWebKit/528.16 (KHTML, like Gecko) Version/4.0 Safari/528.16',
            :browser => 'Safari',
            :browser_version_major => '4',
            :browser_version_minor => '0',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_5_8; ja-jp) AppleWebKit/530.19.2 (KHTML, like Gecko) Version/3.2.3 Safari/525.28.3',
            :browser => 'Safari',
            :browser_version_major => '3',
            :browser_version_minor => '2',
            :os_type => 'Macintosh',
            :os_version => 'OS X 10.5'
        },
        {
            :ua => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ko-KR) AppleWebKit/525.28 (KHTML, like Gecko) Version/3.2.2 Safari/525.28.1',
            :browser => 'Safari',
            :browser_version_major => '3',
            :browser_version_minor => '2',
            :os_type => 'Windows',
            :os_version => 'XP'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; it-it) AppleWebKit/418.9 (KHTML, like Gecko) Safari/419.3',
            :browser => 'Safari',
            :browser_version_major => '2',
            :browser_version_minor => nil,
            :os_type => 'Macintosh',
            :os_version => 'OS X'
        },
        {
            :ua => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/312.8 (KHTML, like Gecko) Safari/312.5',
            :browser => 'Safari',
            :browser_version_major => '1',
            :browser_version_minor => nil,
            :os_type => 'Macintosh',
            :os_version => 'OS X'
        },
        {
            :ua => 'Mozilla/5.0 (Linux; U; Android 2.3.3; de-ch; HTC Desire Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
            :browser => 'Safari',
            :browser_version_major => '4',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => 'Android 2.3'
        },
        {
            :ua => 'Mozilla/5.0 (Linux; U; Android 2.3.4; fr-fr; HTC Desire Build/GRJ22) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
            :browser => 'Safari',
            :browser_version_major => '4',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => 'Android 2.3'
        },
        {
            :ua => 'Mozilla/5.0 (Linux; U; Android 1.6; ar-us; SonyEricssonX10i Build/R2BA026) AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/525.20.1',
            :browser => 'Safari',
            :browser_version_major => '3',
            :browser_version_minor => '1',
            :os_type => 'Linux',
            :os_version => 'Android 1.6'
        },
        {
            :ua => 'Mozilla/5.0 (Linux; U; Android 2.2.1; en-ca; LG-P505R Build/FRG83) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
            :browser => 'Safari',
            :browser_version_major => '4',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => 'Android 2.2'
        },
        {
            :ua => 'Mozilla/5.0 (Linux; U; Android 2.1; en-us; Nexus One Build/ERD62) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17',
            :browser => 'Safari',
            :browser_version_major => '4',
            :browser_version_minor => '0',
            :os_type => 'Linux',
            :os_version => 'Android 2.1'
        },
    ]

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
      assert_equal browser, @user_agents[n].browser, "Testing #{@user_agent_strings[n][:ua]}"
    end
  end

  def test_browser_version_major
    @user_agent_strings.each_index do |n|
      browser_version_major = @user_agent_strings[n][:browser_version_major]
      assert_equal browser_version_major, @user_agents[n].browser_version_major, "Testing #{@user_agent_strings[n][:ua]}"
    end
  end

  def test_browser_version_minor
    @user_agent_strings.each_index do |n|
      browser_version_minor = @user_agent_strings[n][:browser_version_minor]
      assert_equal browser_version_minor, @user_agents[n].browser_version_minor, "Testing #{@user_agent_strings[n][:ua]}"
    end
  end

  def test_os_type
    @user_agent_strings.each_index do |n|
      os_type = @user_agent_strings[n][:os_type]
      assert_equal os_type, @user_agents[n].os_type, "Testing #{@user_agent_strings[n][:ua]}"
    end
  end

  def test_os_version
    @user_agent_strings.each_index do |n|
        os_version = @user_agent_strings[n][:os_version]
        assert_equal os_version, @user_agents[n].os_version, "Testing #{@user_agent_strings[n][:ua]}"
    end
  end

end
