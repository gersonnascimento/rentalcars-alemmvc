require 'rails_helper'

describe NilUser do
  describe '#email' do
    it {expect(subject.email).to eq ''}
  end

  describe '#admin?' do
    it {expect(subject.admin?).to eq false}
  end

  describe '#user?' do
    it {expect(subject.user?).to eq false}
  end

  describe '#persisted?' do
    it {expect(subject.persisted?).to eq false}
  end
end
