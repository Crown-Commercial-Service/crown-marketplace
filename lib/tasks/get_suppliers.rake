module CCS
  require 'rexml/document'
  require 'pg'
  include REXML

  def self.load_suppliers
    xmlfile = File.new('data/' + 'apprenticeships/get_category_contents.xml')
    xmldoc = Document.new(xmlfile)
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.exec_query('create table IF NOT EXISTS app_suppliers (name varchar(255) UNIQUE, level integer);')
      names = XPath.match(xmldoc, '//name').map(&:text)
      names.each do |name|
        query = "DELETE FROM app_suppliers where name = '" + name + "' ; " \
      "insert into app_suppliers ( name,level) values('" + name + "',1);"
        db.query query
      end
    end
  end
end
namespace :db do
  desc 'add supplier data to the database'
  task suppliers: :environment do
    CCS.load_suppliers
  end
end
