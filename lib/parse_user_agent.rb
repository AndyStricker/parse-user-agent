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
    useragent = @user_agent.gsub(/(Opera [\d])/,'Opera\1')
    
    # grab all Agent/version strings as 'agents'
    @agents = Array.new
    @user_agent.split(/\s+/).each {|string| 
      if string =~ /\//
        @agents<< string
      end
    }
    
    # cycle through the agents to set browser and version (MSIE is set later)
    if @agents && @agents.length > 0
        @agents.each {|agent|
          parts = agent.split('/')
          @browser = parts[0]
          @browser_version = parts[1]
          if @browser == 'Firefox'
            @browser_version_major = parts[1].slice(0,3)
            @browser_version_minor = parts[1].sub(@browser_version_major,'').sub('.','')
          elsif @browser == 'Chrome'
            m = @browser_version.match(/(\d+)\.(\d+)\.\d+\.\d+/)
            @browser_version_major = m[1]
            @browser_version_minor = m[2]
            break
          elsif @browser == 'Safari'
            if parts[1].slice(0,3).to_f < 400
              @browser_version_major = '1'
            else
              @browser_version_major = '2'
            end
          elsif @browser == 'Opera'
            m = @browser_version.match(/(\d+)\.(\d+)/)
            @browser_version_major = m[1]
            @browser_version_minor = m[2]
            break
          else
            @browser_version_major = parts[1].slice(0,1)
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
          if parts[1] =~ /^NT/
            @os_type = 'Windows'
            subparts = parts[1].split(/ /,2)
            if subparts[1] == '5'
              @os_version = '2000'
            elsif subparts[1] == '5.1'
              @os_version = 'XP'
            else
              @os_version = subparts[1]
            end
          end
        end
      end
      if property == 'Macintosh'
        @os_type = 'Macintosh'
        @os = property
      end
      if property =~ /OS X/
        @os_type = 'Macintosh'
        @os_version = 'OS X'
        @os = property
      end
      if property =~ /^Linux/
        @os_type = 'Linux'
        @os = property
      end
      if property =~ /^MSIE/
        @browser = 'MSIE'
        @browser_version = property.gsub('MSIE ','').lstrip
        @browser_version_major,@browser_version_minor = @browser_version.split('.')
      end
    }
    self
  end
  

  
end
