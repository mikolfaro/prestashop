require_relative 'test_helper'

module Prestashop
  module Mapper
    describe Category do
      let(:category) { Category.new(attributes_for(:category)) }
      before do
        @settings =  mock 'settings'
        Category.stubs(:settings).returns(@settings)
        Category.any_instance.stubs(:settings).returns(@settings)
      end

      it "should have valid name" do 
        cat = Category.new(attributes_for(:category, name: ';#Apple<>' + LONG_STRING))
        cat.name.length.must_equal 61
      end

      it "should have valid description" do 
        cat = Category.new(attributes_for(:category, description: ';#<a>Apple</a>' + LONG_STRING))
        cat.description.length.must_equal 252
      end

      it "should have valid link rewrite" do 
        category.link_rewrite.must_equal 'apple'
        cat = Category.new(attributes_for(:category, link_rewrite: 'Apple iPhone'))
        cat.link_rewrite.must_equal 'apple-iphone'
      end

      it "should look for category in cache" do 
        Category.expects(:find_in_cache).returns({id: 1})
        category.find_or_create.must_equal 1
      end

      it "should create new one, when is not find in cache" do 
        Category.expects(:find_in_cache).returns(false)
        Category.any_instance.expects(:create).returns({id: 1})
        @settings.expects(:clear_categories_cache)
        category.find_or_create.must_equal 1
      end

      it "should look for category in cache" do
        name = mock 'name'
        name.expects(:lang_search).returns(true)
        cache = [{id_parent: {val: 1}, name: name }]
        @settings.stubs(:categories_cache).returns(cache)
        Category.find_in_cache('Apple', 1).must_equal cache.first
        Category.find_in_cache('Apple', 2).must_equal nil
      end

      it "should cache by calling all" do 
        Category.expects(:all)
        Category.cache
      end

      it "should create from name" do
        cat = mock('category')
        @settings.stubs(:delimiter).returns('|')
        Category.expects(:new).returns(cat)
        cat.expects(:find_or_create).once
        Category.create_from_name 'Apple'
      end

      it "should generate correct hash from string" do
        cat_name = 'Apple||iPhone'
        Category.stubs(:create_from_name).with(cat_name).returns([1,2])
        Category.resolver(cat_name).must_equal({id_category_default: 2, ids_category: [1,2]})
      end

      it "should generate correct hash from array" do 
        cat_name = 'Apple||iPhone||Accessories'
        cat_name2 = 'Apple||Accessories'
        Category.stubs(:create_from_name).with(cat_name).returns([1,2,3])
        Category.stubs(:create_from_name).with(cat_name2).returns([1,4])
        Category.resolver([cat_name, cat_name2]).must_equal({id_category_default: 4, ids_category: [1,2,3,4]})
      end

      it "should generate correct hash from hash" do 
        cat_name = 'Apple||iPhone||Accessories'
        cat_name2 = 'Apple||Accessories'
        Category.stubs(:create_from_name).with(cat_name).returns([1,2,3])
        Category.stubs(:create_from_name).with(cat_name2).returns([1,4])
        Category.resolver(default: cat_name, secondary: cat_name2).must_equal({id_category_default: 3, ids_category: [1,2,3,4]})
      end

      it "should generate correct hash from hash and array" do 
        cat_name = 'Apple||iPhone||Accessories'
        cat_name2 = 'Apple||Accessories'
        cat_name3 = 'Apple||Car'
        Category.stubs(:create_from_name).with(cat_name).returns([1,2,3])
        Category.stubs(:create_from_name).with(cat_name2).returns([1,4])
        Category.stubs(:create_from_name).with(cat_name3).returns([1,5])
        Category.resolver(default: cat_name, secondary: [cat_name2, cat_name3]).must_equal({id_category_default: 3, ids_category: [1,2,3,4,5]})
      end
    end 
  end
end