class Broadcast < ActiveRecord::Base

  @@search_columns = ["user_id", "content"]

  # The only restriction is that broadcasts must have some data to
  # be valid and an associated broadcaster (user_id)
  validates_presence_of :content

  belongs_to :user
  has_and_belongs_to_many :feeds

  def to_s
    result = "id: " + id.to_s + " content: " + content + " created_at: " + created_at
    if user
      result += " user: " + user.id.to_s
    end
    result
  end

  def self.per_page
    8
  end

  def self.search_columns
    @@search_columns
  end

  def self.searchable_by(*column_names)
    @@search_columns = []
    [column_names].flatten.each do |name|
      @@search_columns << name
    end
  end

  def self.search_conditions(query, fields=nil)
    return nil if query.blank?
    fields ||= @@search_columns

    # Split the query by commas as well as spaces, just in case
    words = query.split(",").map(&:split).flatten

    binds = {} # Query binding names for substitution to avoid SQL injection!
    or_frags = [] # OR fragments
    count = 1 # To help give bind symbols a unique name
    #cols = columns_hash() # All the column objects
    #puts "columns= #{cols}"

    words.each do |word|
      search_frags = [fields].flatten.map do |field|
        # If a string field then construct a LIKE frag
        # else if a numeric field then look for equality
        #puts "field= #{field}"
        #column = cols[field.to_s]
        #puts "column before = #{column}"
        #unless column.blank?
        #if column.text?
        "LOWER(#{field}) LIKE :word#{count}"
        #elsif column.
        #end
        #end
      end
      or_frags << "(#{search_frags.join(" OR ")})"
      binds["word#{count}".to_sym] = "%#{word.to_s.downcase}%"
      count += 1
    end
    puts "search conditions: #{[or_frags.join(" AND "), binds].to_s}"
    [or_frags.join(" AND "), binds]
  end
end
