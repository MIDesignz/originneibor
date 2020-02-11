class UserDatatable < AjaxDatatablesRails::Base
  def view_columns
    @view_columns ||= {
      name: { source: "User.name", searchable: true },
      email:  { source: "User.email", searchable: true }
    }
  end

  def fetch_records
    get_raw_records
  end


  def data
    records.map do |record|
      [
        record.name,
        record.email
      ]
    end
  end

  private
  def get_raw_records
    User.all
  end

  def sortable_columns
    @sortable_columns ||= ['User.name', 'User.email']
  end

  def searchable_columns
    @searchable_columns ||= ['User.name', 'User.email']
  end


  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
