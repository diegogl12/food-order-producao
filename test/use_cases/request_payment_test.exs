defmodule FoodOrderProducao.UseCases.RequestPaymentTest do
  use ExUnit.Case

  alias FoodOrderProducao.Domain.Entities.Checkout
  alias FoodOrderProducao.Domain.Entities.Payment
  alias FoodOrderProducao.Domain.Entities.PaymentStatus
  alias FoodOrderProducao.UseCases.RequestPayment

  describe "execute/4" do
    test "should request payment" do
      checkout = %Checkout{
        id: UUID.uuid4(),
        order_id: "1",
        amount: 100,
        customer_id: "1",
        payment_method: "credit_card"
      }

      payment_id = UUID.uuid4()
      payment = %Payment{
        id: payment_id,
        order_id: UUID.uuid4(),
        external_id: UUID.uuid4(),
        amount: 100,
        payment_date: NaiveDateTime.utc_now(),
        payment_method: "credit_card",
        created_at: NaiveDateTime.utc_now()
      }

      payment_provider_mock = %{
        perform_payment: fn checkout ->
          {:ok, payment}
        end
      }

      payment_repository_mock = %{
        create: fn _payment ->
          {:ok, payment}
        end
      }

      payment_status_repository_mock = %{
        create: fn _status ->
          {:ok, %PaymentStatus{id: UUID.uuid4(), payment_id: payment_id, status: "pending"}}
        end
      }

      result = RequestPayment.execute(checkout, payment_provider_mock, payment_repository_mock, payment_status_repository_mock)

      assert result == {:ok, payment}
    end
  end
end
