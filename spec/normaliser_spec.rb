# coding: utf-8

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'onix'

context "ONIX::Normaliser", "with a simple short tag file" do

  before(:each) do
    @data_path = File.join(File.dirname(__FILE__),"..","data")
    @filename  = File.join(@data_path, "short_tags.xml")
    @outfile   = @filename + ".new"
  end

  after(:each) do
    File.unlink(@outfile) if File.file?(@outfile)
  end

  specify "should correctly convert short tag file to reference tag" do
    ONIX::Normaliser.process(@filename, @outfile)

    File.file?(@outfile).should be_true
    content = File.read(@outfile)
    content.include?("<m174>").should be_false
    content.include?("<FromCompany>").should be_true
  end

end

context "ONIX::Normaliser", "with an ISO-8859-1 file" do

  before(:each) do
    @data_path = File.join(File.dirname(__FILE__),"..","data")
    @filename  = File.join(@data_path, "iso_8859_1.xml")
    @outfile   = @filename + ".new"
  end

  after(:each) do
    File.unlink(@outfile) if File.file?(@outfile)
  end

  specify "should correctly convert an iso-8859-1 file to UTF-8" do
    ONIX::Normaliser.process(@filename, @outfile)

    File.file?(@outfile).should be_true
    content = File.read(@outfile)

    content.include?("ISO-8859-1").should be_false
    content.include?("UTF-8").should be_true

    `isutf8 #{File.expand_path(@outfile)}`.strip.should eql("")
  end

end

context "ONIX::Normaliser", "with an file using entities" do

  before(:each) do
    @data_path = File.join(File.dirname(__FILE__),"..","data")
    @filename  = File.join(@data_path, "entities.xml")
    @outfile   = @filename + ".new"
  end

  after(:each) do
    File.unlink(@outfile) if File.file?(@outfile)
  end

  specify "should correctly convert named entities to numeric entities" do
    ONIX::Normaliser.process(@filename, @outfile)

    File.file?(@outfile).should be_true
    content = File.read(@outfile)

    content.include?("&ndash;").should be_false
    content.include?("&#x02013;").should be_true
  end
end
