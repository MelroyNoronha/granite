# frozen_string_literal: true

require "test_helper"

class FlakyEnvVariableTest < ActiveSupport::TestCase
  def test_one_check_the_env_value
    assert_equal "test", Rails.env
  end

  def test_two_check_the_env_value
    assert_equal "test", Rails.env
  end

  def test_three_check_the_env_value
    assert_equal "test", Rails.env
  end

  def test_four_check_the_env_value
    assert_equal "test", Rails.env
  end

  def test_five_check_the_env_value
    assert_equal "test", Rails.env
  end

  def test_update_the_env_value
    Rails.env = "production"
    assert_equal "production", Rails.env
    Rails.env = "test"
  end
end
