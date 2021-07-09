defprotocol Globolive.Core.Schedulable do
  @moduledoc """
  Provides a protocol that, when implemented, allows the calculation of the data's duration.
  """

  @doc """
  Calculate the duration of the given data as a number of seconds.
  """
  @spec duration(term) :: non_neg_integer
  def duration(value)
end
