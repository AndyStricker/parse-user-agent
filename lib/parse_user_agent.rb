# Original Code by Jackson Miller (Website http://jaxn.org)

class ParseUserAgent

  attr_reader :os_type, :os_version
  attr_reader :browser, :browser_version_major, :browser_version_minor

  def parse(user_agent)
    if '-' == user_agent
      raise 'Invalid User Agent'
    end

    @user_agent = user_agent

    # fix Opera
    #useragent =~ s/Opera (\d)/Opera\/$1/i;
    useragent = @user_agent.gsub(/Opera (\d)/, 'Opera/\1')

    # grab all Agent/version strings as 'agents'
    @agents = Array.new
    useragent.split(/\s+/).each {|string|
      if string =~ /\//
        @agents<< string
      end
    }

    version_token = nil

    # cycle through the agents to set browser and version (MSIE is set later)
    if @agents && @agents.length > 0
        @agents.each {|agent|
          parts = agent.split('/')
          @browser = parts[0]
          @browser_version = parts[1]
          @browser = 'Firefox' if @browser == 'Iceweasel'
          if (@browser == 'Firefox')
            m = @browser_version.match(/(\d+)\.(\d+)/)
            if m
              @browser_version_major = m[1]
              @browser_version_minor = m[2]
            else
              @browser_version_major = parts[1].slice(0,3)
              @browser_version_minor = parts[1].sub(@browser_version_major,'').sub('.','')
            end
            break
          elsif @browser == 'Chrome'
            m = @browser_version.match(/(\d+)\.(\d+)(\.\d+\.\d+)?/)
            if m
              @browser_version_major = m[1]
              @browser_version_minor = m[2]
            end
            break
          elsif @browser == 'Safari'
            if parts[1].slice(0,3).to_f < 400
              @browser_version_major = '1'
            else
              @browser_version_major = '2'
            end
          elsif @browser == 'Version'
            version_token = @browser_version
          elsif @browser == 'Opera'
            m = @browser_version.match(/(\d+)\.(\d+)/)
            @browser_version_major = m[1]
            @browser_version_minor = m[2]
            break
          else
            @browser_version_major = parts[1].slice(0,1) unless @browser == 'Gecko'
          end
        }
    end

    # grab all of the properties (within parens)
    # should be in relation to the agent if possible
    @detail = @user_agent
    @user_agent.gsub(/\((.*)\)/,'').split(/\s/).each {|part| @detail = @detail.gsub(part,'')}
    @detail = @detail.gsub('(','').gsub(')','').lstrip
    @properties = @detail.split(/;\s+/)

    # cycle through the properties to set known quantities
    @properties.each {|property|
      if property =~ /^Win/
        @os_type = 'Windows'
        @os = property
        if parts = property.split(/ /,2)
          if parts[0] == 'Windows' and parts[1] =~ /^Phone/
            @os_type = 'Windows Phone'
            subparts = parts[1].split(/ /,2)
            @os_version = subparts[1]
          elsif parts[1] =~ /^NT/
            @os_type = 'Windows'
            subparts = parts[1].split(/ /,2)
            if (subparts[1] == '5') or (subparts[1] == '5.0')
              @os_version = '2000'
            elsif subparts[1] == '5.1'
              @os_version = 'XP'
            elsif subparts[1] == '5.2'
              @os_version = 'XP 64/Server 2003'
            elsif subparts[1] == '5.2 x64'
              @os_version = 'XP 64/Server 2003'
            elsif subparts[1] == '6.0'
              @os_version = 'Vista/Server 2008'
            elsif subparts[1] == '6.1'
              @os_version = '7/Server 2008 R2'
            elsif subparts[1] == '6.2'
              @os_version = '8'
            else
              @os_version = 'NT'
              @os_version += ' ' + subparts[1] if subparts and subparts[1].length > 0
            end
          elsif parts[1] =~ /^(?:95|98|ME)/
              @os_version = parts[1].slice(0, 2)
          end
        end
      end
      if property =~ /^(iPod|iPhone|iPad)/
        @os_type = 'iOS'
        @os_version = $1
      end
      if property == 'Macintosh'
        @os_type = 'Macintosh'
        @os = property
      end
      if property =~ /OS X/
        m = property.match(/OS X\s*?(\d+[._]\d+)/)
        if (@os_type == 'iOS')
          if m
            @os_version = m[1].gsub('_', '.')
          end
        else
          @os_type = 'Macintosh'
          if m
            @os_version = 'OS X ' + m[1].gsub('_', '.')
          else
            @os_version = 'OS X'
          end
          @os = property
        end
      end
      if property =~ /^CPU iPhone OS (\d+[._]\d+)/
        if @os_version
          @os_version = @os_version + ' iOS ' + $1.gsub('_', '.')
        else
          @os_version = 'iOS ' + $1.gsub('_', '.')
        end
      end
      if property =~ /(?:PPC|PowerPC)/
        @os_type = 'Macintosh' unless @os_type
        @os_version = 'MacOS' unless @os_version
      end
      if property =~ /Linux/
        @os_type = 'Linux'
        @os = property
      end
      if (property =~ /^MSIE/) and not (@browser == 'Opera')
        @browser = 'MSIE'
        @browser_version = property.gsub('MSIE ','').lstrip
        @browser_version_major,@browser_version_minor = @browser_version.split('.')
      end
      if (property =~ /^IE\s/)
        @browser = 'MSIE'
        @browser_version = property.gsub('IE ', '').lstrip
        @browser_version_major,@browser_version_minor = @browser_version.split('.')
      end
      if property =~ /^SunOS/
        @os_type = 'SunOS'
        @os_version = property.gsub('SunOS ', '').lstrip
      end
      if property =~ /(Free|Open|Net)BSD/
        @os_type = $1 + 'BSD'
      end
      if property =~ /^Win/
        if property =~ /WinNT\d+/
          @os_type = 'Windows'
          @os_version = 'NT'
          m = property.match(/WinNT(\d+(?:\.\d+)?)/)
          @os_version = 'NT ' + m[1] if m
        elsif property =~ /Win(95|98|ME)/
          @os_type = 'Windows'
          @os_version = $1
        elsif property =~ /Windows CE/
          @os_type = 'Windows'
          @os_version = 'CE'
        end
      end
      if property =~ /^CrOS/
        @os_type = 'Linux'
        @os_version = 'Chrome OS';
      end
      if property =~ /^Android (\d+\.\d+)/
        @os_type = 'Linux'
        @os_version = 'Android ' + $1
      elsif property =~ /^Android/
        @os_type = 'Linux'
        @os_version = 'Android'
      end
      if property =~ /^(Mobile|Tablet)$/ and $os_version =~ /^Android/
        @os_type = 'Linux'
        @os_version = 'Android ' + $1
      end
      if (property =~ /^rv:/) and (@browser != 'Firefox')
        @browser_version = property.split(':', 1)[-1]
        m = @browser_version.match(/(\d+)\.(\d+)/)
        if m
          @browser_version_major = m[1]
          @browser_version_minor = m[2]
        else
          @browser_version_major = @browser_version
        end
      end
    }
    if @browser == 'Gecko'
        @browser = 'Mozilla'
    end
    if (@browser == 'Safari') and version_token
      @browser_version = version_token
      m = version_token.match(/(\d+)\.(\d+)/)
      if m
          @browser_version_major = m[1]
          @browser_version_minor = m[2]
      end
    end
    self
  end



end
