Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id

      String :first_name, null: false
      String :last_name, null: false
      String :email,  null: false
      String :phone, null: false
      String :timestamp, null: false
    end
  end
end
