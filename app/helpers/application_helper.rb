module ApplicationHelper
  # Returns a random address placeholder for the forecast input form.
  # Simply adds a small dash of dynamism to an otherwise static page.
  def random_placeholder_address
    [
      '2800 E Observatory Rd, Los Angeles, CA 90027',
      '30 Main St, Brattleboro, VT 05301',
      '233 S Wacker Dr, Chicago, IL 60606',
      '52807 Paradise Rd E, Ashford, WA 98304',
      '1005 W Burnside St, Portland, OR 97209',
      '401 South St, Key West, FL 33040',
      '713 Simundson Dr, Point Roberts, WA 98281',
      '6554 Park Blvd, Joshua Tree, CA 92252',
      '100 34th Ave, San Francisco, CA 94121',
      '225 North Avenue NW, Atlanta, GA 30332'
    ].sample
  end
end
