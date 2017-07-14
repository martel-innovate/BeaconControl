class CreateCouponAttachments < ActiveRecord::Migration
  def change
    create_table :coupon_attachments do |t|
      t.references :coupon, index: true
      t.string :file
      t.string :type

      t.timestamps null: false
    end
    add_foreign_key :coupon_attachments, :coupons
  end
end
