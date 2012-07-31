class ChangeDomainIdColumnInResources < ActiveRecord::Migration
  def up
  	change_column_null :resources, :domain_id, false
  end

  def down
  	change_column_null :resources, :domain_id, true
  end
end
