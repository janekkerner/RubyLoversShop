# frozen_string_literal: true

class User < ApplicationRecord
  after_save_commit :create_shopping_cart
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :shopping_cart, dependent: :destroy
end
