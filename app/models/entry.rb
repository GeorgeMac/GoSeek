class Entry

    include Tire::Model::Persistence

    validates_presence_of :title, :url

    property :title
    property :description,   :analyzer => 'snowball',    :default => "Golang Package"
    property :url,           :type     => 'string'

    def self.search(params)
        tire.search(page: params[:page], per_page: 5) do
            query do
                dis_max do
                    query { match "title", params[:q] }
                    query { match "description", params[:q] }
                end
            end if params[:q].present?
        end
    end

    after_save do
      Entry.index.refresh
    end

end