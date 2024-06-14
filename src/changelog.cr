class Version::ChangeLog
  alias TagInfo = {String?, String, String, Hash(String, Array(Commit))}

  def self.build(*, head : String? = nil)
    markdown(fetch_commits(head))
  end

  def self.fetch_commits(head : String? = nil)
    last_tag = head
    commits = [] of Commit
    tags = [] of TagInfo

    `git log --format="%h,%as,%D,%s" --decorate-refs refs/tags`.each_line do |line|
      hash, date, tag, subject = line.split ',', 4
      tag = /tag: (.*)/.match(tag).try(&.[1])

      last_tag = tag if last_tag.nil?

      if tag != last_tag && tag
        tags << {last_tag, tag, date, commits.dup.sort_by { |c| c.scope || "" }.group_by(&.pretty_type)}

        last_tag = tag
        commits.clear
      else
        commit = Commit.from_s(hash, subject)

        STDERR.puts "ERROR: #{commit}: `(#{hash}) #{subject}`" if commit.is_a? Error && Config.verbose

        commits << commit unless commit.is_a? Error ||
                                 commits.any? { |it| it.summary == commit.summary } ||
                                 should_skip? commit
      end
    end

    tags
  end

  def self.should_skip?(c : Commit)
    c.type == "chore" && c.scope == "release"
  end

  def self.markdown(tags : Array(TagInfo))
    String.build do |s|
      tags.each do |(now, old, date, types)|
        s << "## [#{now}](#{remote}/compare/#{old}...#{now}) (#{date})"
        s << EOL * 2

        if types.empty?
          s << "_no notable changes_"
          s << EOL * 2
        end

        types.each do |(type, commits)|
          s << "### #{type}"
          s << EOL * 2

          commits.each do |commit|
            s << "* "
            s << "**#{commit.scope}:** " if commit.scope
            s << "#{commit.subject} ([#{commit.hash}](#{remote}/commit/#{commit.hash}))"
            s << EOL
          end
          s << EOL
        end
      end
    end
  end

  private def self.remote
    @@remote ||= case `git remote get-url #{`git remote`}`
                 when /^git@([^:]*):([^.]*)(.git)?/
                   "https://#{$1}/#{$2}"
                 when /^https?:/
                   $0
                 else
                   raise "unsupported remote url scheme"
                 end
  end
end
