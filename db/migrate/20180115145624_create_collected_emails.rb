class CreateCollectedEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :collected_emails do |t|
      t.string :email
      t.belongs_to :shop, foreign_key: true

      t.timestamps
    end
  end
end
