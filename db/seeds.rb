# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# 2.1.1 :002 > InventoryItem.all.map(&:attributes).map{|ii| ii.symbolize_keys.slice(:title, :price, :city_id)}.map{|ii| ii[:price] = ii[:price].to_f; ii}
# D, [2014-04-17T17:55:49.727178 #56683] DEBUG -- :   InventoryItem Load (0.7ms)  SELECT "inventory_items".* FROM "inventory_items"
#  => [{:title=>"Mike's Famous Pork on Pork", :price=>5.99, :city_id=>1}, {:title=>"Original PowerBook 100", :price=>6500.0, :city_id=>1}]
InventoryItem.create!([
  {:title=>"Mike's Famous Pork on Pork", :price=>5.99, :city_id=>1},
  {:title=>"Original PowerBook 100", :price=>6500.0, :city_id=>1}
])
