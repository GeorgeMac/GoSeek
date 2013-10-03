class Entry < ActiveRecord::Base

    include Tire::Model::Search
    include Tire::Model::Callbacks

    validates_presence_of :title, :url

    mapping do
        indexes :title,         :boost    => 3.0
        indexes :url,           :type     => 'string'
        indexes :description,   :analyzer => 'snowball',    :default => "Golang Package"
        indexes :forks,         :type     => 'integer'
        indexes :stars,         :type     => 'integer'
    end

    def self.search(params)
        tire.search(page: params[:page], per_page: 5) do
            query do
                dis_max do
                    query { match "title", params[:q] }
                    query { match "description", params[:q] }
                end
            end if params[:q].present?
            sort do
                by :stars,  'desc'
                by :forks,  'desc'
                by :_score, 'desc'
            end
        end
    end

    after_save do
      Entry.index.refresh
    end

end