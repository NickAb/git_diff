require "test_helper"

class DeletionTest < MiniTest::Unit::TestCase
  def setup
    @deletion = GitDiff::Line::Deletion.new("- deletion")
  end

  def test_from_string_with_a_deletion
    deletion = GitDiff::Line::Deletion.from_string("- deletion")

    refute_nil deletion
    assert_instance_of GitDiff::Line::Deletion, deletion
  end

  def test_from_string_without_a_deletion
    assert_nil GitDiff::Line::Deletion.from_string("deletion")
  end

  def test_addition_is_false
    refute @deletion.addition?
  end

  def test_deletion_is_true
    assert @deletion.deletion?
  end
end