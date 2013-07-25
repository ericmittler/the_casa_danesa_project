require 'spec_helper'

describe UserActivity do
  it { should belong_to :user }
end
