class Version::Bumper
  def self.bump : Nil
    unless uncommitted_changes.empty?
      puts "❌ you have uncommitted changes"
      exit
    end

    current_tag = `git describe --tags --abbrev=0 2>/dev/null`.strip

    unless $?.success?
      `git tag v1.0.0`
      puts "created tag v1.0.0"
      exit
    end

    current_ver = SemVer.from_s current_tag

    raise current_ver.to_s if current_ver.is_a? Error

    max : SemVer::Bump = :patch

    `git log --oneline --format="%s" #{current_tag}..HEAD`.each_line do |line|
      commit = Commit.from_s(line, line)
      if commit.is_a? Error
        next
      end

      if commit.breaking
        max = :major
      elsif commit.type == "feat"
        max = :minor
      end
    end

    new_ver = current_ver.bump(max)

    File.write "CHANGELOG.md", Version::ChangeLog.build(head: new_ver.to_s)

    puts "✔ changelog written"

    `git add CHANGELOG.md`
    `git commit -m "chore(release): #{new_ver}"`

    puts "✔ commit created"

    `git tag #{new_ver}`

    puts "✔ tag created"
  end

  private def self.uncommitted_changes
    `git status --porcelain`.lines.map(&.strip).reject(&.empty?)
  end
end
