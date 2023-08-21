Puppet::Functions.create_function(:'autofs::mapping_content') do
  dispatch :mapping_content do
    param 'String', :key
    param 'Autofs::Location', :location
    optional_param 'Autofs::Options', :options
    return_type 'String'
  end

  def format_options(options)
    options = Array(options).join(',')
    return '' if options.empty?
    options.prepend('-')
  end

  def format_mount(mount, hash)
    options = format_options(hash['options'])
    host = hash['host'] || ''
    path = hash['path']

    if options.empty?
      "#{mount} #{host}:#{path}"
    else
      "#{mount} #{options} #{host}:#{path}"
    end
  end

  def format_location(location)
    if location.values.any? { |value| value.is_a?(Hash) }
      location.map { |mount, hash|
        format_mount(mount, hash)
      }.join(" \\\n\t")
    else
      "#{location.fetch('host', '')}:#{location['path']}"
    end
  end

  def mapping_content(key, location, options = [])
    options = format_options(options)
    location = format_location(location)

    if options.empty?
      "#{key}\t#{location}"
    else
      "#{key}\t#{options}\t#{location}"
    end
  end
end
