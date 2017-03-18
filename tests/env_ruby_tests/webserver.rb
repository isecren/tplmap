require "cuba"
require "cuba/safe"

require 'tilt'
require 'slim'

Cuba.plugin Cuba::Safe

Cuba.define do
  on get do
    on "reflect/:engine" do |engine|
      # Keep the formatting a-la-python
      on param("inj"), param("tpl", "%s") do |inj, tpl|
        
        tpl = tpl.gsub('%s', inj)
        
        case engine
        when "eval"
          res.write eval(tpl)
        when "slim"

          template = Tilt['slim'].new() {|x| tpl}
          res.write template.render
          
        else
          res.write "#{engine} #{inj} #{tpl}" 
        end
        
      end
    end
    on "blind/:engine" do |engine|
      # Keep the formatting a-la-python
      on param("inj"), param("tpl", "%s") do |inj, tpl|
        
        tpl = tpl.gsub('%s', inj)
        
        case engine
        when "eval"
          eval(tpl)
        when "slim"
          template = Tilt['slim'].new() {|x| tpl}
          template.render
        else
          res.write "blind #{engine} #{inj} #{tpl}" 
        end
        
      end
    end
    on 'shutdown' do
      exit!
    end
  end
end