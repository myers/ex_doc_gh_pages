defmodule ExDocGhPages do
end

defmodule Mix.Tasks.Docs.Publish do
  use Mix.Task

  @shortdoc "Generate HTML documentation then publish to Github"

  @moduledoc """
  A test task.
  """
  def run(_) do
    # is there is already a remote gh-pages branch?
    # no ->  create "docs" as an orphan branch
    # yes -> System.cmd "git clone --branch gh-pages `git config --get remote.origin.url` docs"
    # 

    gh_pages_branches = System.cmd("git branch --all --no-color") |> String.split("\n") |> Enum.filter(&String.ends_with?(&1, "remotes/origin/gh-pages"))
    if List.size(gh_pages_branches) do
      System.cmd "git clone --branch gh-pages `git config --get remote.origin.url` docs"
    else
      File.mkdir!("docs")
      File.cp_r(".git", "docs/.git")
      File.cd! "docs", fn ->
        System.cmd "git checkout --orphan gh-pages"
      end
    end

    Mix.Task.run "docs"

    File.cd! "docs", fn ->
      System.cmd "git add -A ."
      System.cmd "git commit -m \"Updated docs\""
      #System.cmd "git push origin gh-pages"
    end

    #File.rm_rf! "docs"

    IO.puts IO.ANSI.escape("%{green}Updated docs pushed to origin/gh-pages")
  end
end
