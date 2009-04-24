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
   url '/pref',  :pref
   url '/about', :about

   $configFile = ".amaras/RWTestConfig.yml"
   $numbers = {} 
    
    
   #Function to save
   def saveConfig(configFile, config)
      FileUtils.mkdir_p '.amaras'
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
      topMenu(1)
      
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
   
   def about
      @app = app
      topMenu(0)
      stack {
         para "Testing Packaged Shoes File Read Write" 
         para "Acknowledgements" 
         para "Copyright" 
      }
   end
   
   def pref
      @app = app
      topMenu(2)
      stack {
         para "No Prefs"
      }
      
   end 
   
   def topMenu (tabNo)
      
      #Change settings here as required
      inactiveTabColor = "#B0B0B0"
      mainBodyColor    = "#D0D0D0"
      topColor         = "#E0E0E0"
      noOfTabs         = 3
      tabWidth         = 60
      tabHeight        = 30
      tabOverlay       = 8
      ##################################
      #Order and links of tabs
      names = Array.new
      names[0] = {:name=>"about", :link=>"/about"}
      names[1] = {:name=>"main",  :link=>"/"}
      names[2] = {:name=>"prefs", :link=>"/pref"}
      ##################################
      
      background mainBodyColor
      #Make background for tabs a lighter colour
      background (topColor, :height=> (tabHeight-tabOverlay))

      #Add black line under tabs
      stroke black
      @app.line(0,(tabHeight-tabOverlay),@app.width(),(tabHeight-tabOverlay))
      
      #Do not alter calculations for tabs
      tabsSpace = @app.width() / (noOfTabs + 1)
      currentTabCentre = tabsSpace
      indentamount = Array.new
      #Loop and draw tabs
      (0... noOfTabs).each do |i|
         #Deactive tabs different colour
         if i == tabNo
            fill mainBodyColor
         else 
            fill inactiveTabColor
         end
         #Calculate position and size of tabs
         currentTabStart = currentTabCentre - (tabWidth/2)
         indentamount[i]  = currentTabStart
         @app.rect(currentTabStart,2,tabWidth, (tabHeight-2+5), :curve=>12)
         currentTabCentre  = currentTabCentre + tabsSpace
         
         #Add black line to the bottom of deactivated tabs
         if i != tabNo
            @app.line(currentTabStart,(tabHeight-8),(currentTabStart+tabWidth),(tabHeight-8))
         end
         
         #Set Tab Text Here
         @app.flow (:left => indentamount[i], :width => tabWidth) { 
           para (link(names[i][:name], :click=>names[i][:link],  :stroke => black, :underline => "none"), :align => "center")
         }
         
      end
      
      #Cover up the bottom of the tabs so they have square bottom
      fill   mainBodyColor
      stroke mainBodyColor
      @app.rect(0, (tabHeight-tabOverlay+1), @app.width(), (tabOverlay+4))
   
      #Put pen back to black
      stroke black
      
      #Reload Config file on every tab change
      @config = loadConfig($configFile)
   end
   
end
Shoes.app :title => "Shoes Write Read Test",  :width=>400, :height=>500