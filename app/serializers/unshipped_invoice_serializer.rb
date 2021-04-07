class UnshippedInvoiceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :potential_revenue
  # attribute :potential_revenue do |invoice| 
  #   invoice.potential_revenue
  # end
end
