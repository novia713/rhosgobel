#!/usr/bin/ruby
# -*- coding: utf-8

#gem install green_shoes
require 'pp'
sa = `drush sa`
#pp sa.split("\n");

begin
 require 'green_shoes'
rescue LoadError
  puts "please, install GreenShoes with '#gem install green_shoes'"
  exit
end

def go( a, c)
    return nil if @alias.nil?
    @box.text = "working ..."
    @lowtext.text = "working ..."
    out = `drush @#{a} #{c} 2>&1 | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"`
    @box.text = out
    @lowtext.text = a
    
    File.open("rhosgobel.log", 'a') {|f| f.write(out) }
end

@alias   = nil
@box     = nil
@lowtext = nil

    
 Shoes.app :title=> "Rhosgobel :: Drush Assistant", :height=> 503 do
     
   #general
   background "#DFA".."#FDA"
   #icon "rabbitwarren.png"
     
   #combo
   flow width: 330 do 	
     para "Choose an alias:"; list_box items: sa.split("\n"), choose: "none" do |list|
       @alias = list.text
       go(@alias, 'st')
     end
   end
   # cc, cron
   flow width: 270 do
           button "cc all" do
       		 go(@alias, 'cc all') unless @alias.nil?
           end

           button "cron" do
             go(@alias, 'core-cron') unless @alias.nil?
           end
       
       	   logo_about = image "drush_logo.png"
       	   logo_about.click{
           	  Shoes.app title: "Rhosgobel", width: 200, height: 200 do 
              #background image "rabbitwarren.png"
              background "#DFA".."#FDA"
              stack do
                img = image "rabbitwarren.png"
                img.move 30, 10
                para "(c) 2014 leandro@leandro.org", align: 'center', stroke: darkslateblue, top: 140

              end
              end
           }
   end
     
   # textbox 
   stack width: 530 do
     @line = edit_line width: 530
       keypress do |key| 
         go(@alias, @line.text) if (key == "\n")
       end
   end
     
   # button
   stack width: 70 do
     @btn = button "Execute" do
         #pp @line.text
         if ( @line.text != ""  && @line.text != "none") then
            go(@alias,@line.text)
            # system('ls -al', :out => ['/tmp/log', 'a'], :err => ['/tmp/log', 'a'])
         end
            end
   end
       
   # textarea
   stack do
     @box = edit_box text: "First, please choose an alias", width: 600, height: 400
     @lowtext = inscription "No alias selected"

   end
 end