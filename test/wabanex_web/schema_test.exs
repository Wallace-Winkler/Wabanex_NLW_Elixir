defmodule WabanexWeb.SchemaTest do
  use WabanexWeb.ConnCase, async: true

  alias Wabanex.User
  alias Wabanex.Users.Create

  describe "users queries" do
    test "when a valid id is given, return the user", %{conn: conn} do
      params = %{email: "wall@gmail.com", name: "Wallace", password: "123456"}

    {:ok, %User{id: user_id}} = Create.call(params)

    query = """
      {
        getUser(id: "#{user_id}"){
          name
          email
        }
      }
    """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      expected_response = %{
        "data" => %{
          "getUser" => %{
            "email" => "wall@gmail.com",
            "name" => "Wallace"
          }
        }
      }

      assert response == expected_response
    end
  end

  describe "users mutations" do
    test "when all params are valid, creates the user", %{conn: conn} do
      mutation = """
        mutation {
          createUser(input: {
            name: "Felipe", email: "felp@gmail.com", password: "123456"
          }){
            id
            name
          }
        }
      """
      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{"data" => %{"createUser" => %{"id" => _id, "name" => "Felipe"}}} = response
    end
  end
end
