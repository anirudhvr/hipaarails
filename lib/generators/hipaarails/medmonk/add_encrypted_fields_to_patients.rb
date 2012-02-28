class AddEncryptedFieldsToPatients < ActiveRecord::Migration
    include AttrEncrytped
    def self.up
        add_column :patients, :encrypted_first_name, :string
        add_column :patients, :encrypted_last_name, :string
        add_column :patients, :encrypted_email, :string
        add_column :patients, :encrypted_address, :string
        add_column :patients, :encrypted_city, :string
        add_column :patients, :encrypted_state, :string
        add_column :patients, :encrypted_zip, :integer
        add_column :patients, :encrypted_gender, :string
        add_column :patients, :encrypted_med, :string
        add_column :patients, :encrypted_dob, :string

        Patient.reset_column_information # need this to write back



        Patient.all.each { |p|
            encrypted_first_name = 
                p.update_attribute :encrypted_first_name, SampleApp::Application

    end

    def self.down
        remove_column :versions, :object_changes
    end
end
