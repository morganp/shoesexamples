 #
 # ShoesWriteReadTest
 # Copyright (C) 2009  Morgan Prior
 # 
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 # 
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 # 
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 # 
 # Contact morgan.prior@gmail.com
 # http://munkymorgy.blogspot.com
 #
 # Reuse does not require permission or credit, but I would appreciate 
 # being credited for the original layout. Morgan
 #
 #

require 'yaml'
   
class CanonicalConversion < Shoes
   url '/',      :index

   Dir.chdir(File.dirname($PROGRAM_NAME))
   $configFile = File.dirname($PROGRAM_NAME) + "/.amaras/RWTestConfig.yml"
   $numbers = {} 
    
    
   #Function to save
   def saveConfig(configFile, config)
      FileUtils.mkdir_p "#{File.dirname($PROGRAM_NAME)}/.amaras"
      open(configFile, 'w') {|f| YAML.dump(config, f)}
   end
    
   #Function to Load Settings
   def loadConfig(configFile)
      config = {}
      #do this to set parameters that might be missing from the yaml file
      config[:intBits]  = "6"
      config[:fracBits] = "2"
      if File.exist?(configFile)
         config.update(open(configFile) {|f| YAML.load(f) })
      end
      return config
   end
   
   def index
      @app = app
      #Reload Config file on every tab change
      @config = loadConfig($configFile)
      
      stack {
         flow { 
            para "Integer Bits"
            @intbitbutton = edit_line(@config[:intBits])
         }
         flow {
            para "Fractional Bits"
            @fracbitbutton = edit_line(@config[:fracBits])
         }
         @savebutton = button("Set")
      }
      
      @savebutton.click {
         @config[:intBits] = @intbitbutton.text
         @config[:fracBits] = @fracbitbutton.text
         saveConfig($configFile, @config)
      }
      
   end
      
end
Shoes.app :title => "Shoes Write Read Test",  :width=>400, :height=>500