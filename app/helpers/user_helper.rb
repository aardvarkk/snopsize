module UserHelper
  def recurse_categorized_snops(categories, &block)
  	categories.each do |category|
  	  # yield to the caller to do whatever with the snops for the category
  	  yield(category.snops, category.name)
  	
  	  # recurse on each child of the category
  	  recurse_categorized_snops(category.children, &block) 
  	end
  end
end
