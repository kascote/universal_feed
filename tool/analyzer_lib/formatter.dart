import 'package:universal_feed/universal_feed.dart';

import 'inspector.dart';

/// Formats feed inspection results for console output
class ReportFormatter {
  ReportFormatter({
    this.maxLineLength = 100,
    this.maxContentPreview = 200,
  });

  final int maxLineLength;
  final int maxContentPreview;

  /// Format an inspection result for display
  String format(InspectionResult result) {
    final buffer = StringBuffer();
    final feed = result.feed;

    buffer
      ..writeln('═' * maxLineLength)
      ..writeln('FEED: ${feed.title ?? "(untitled)"}')
      ..writeln('═' * maxLineLength)
      ..writeln()
      ..writeln('Format: ${feed.meta.kind.name} ${feed.meta.version}');

    if (!feed.meta.extensions.extensionsIsEmpty) {
      buffer.writeln('Extensions: ${feed.meta.extensions}');
    }
    buffer.writeln();

    _writeSection(buffer, 'FEED METADATA');
    _writeField(buffer, 'GUID', feed.guid);
    _writeField(buffer, 'Title', feed.title);
    _writeField(buffer, 'Description', feed.description);
    _writeField(buffer, 'HTML Link', feed.htmlLink?.href);
    _writeField(buffer, 'XML Link', feed.xmlLink?.href);
    _writeField(buffer, 'Language', feed.language);
    _writeField(buffer, 'Copyright', feed.copyright);
    _writeField(buffer, 'Docs', feed.docs);
    _writeTimestamp(buffer, 'Published', feed.published);
    _writeTimestamp(buffer, 'Updated', feed.updated);

    // Generator
    if (feed.generator != null) {
      final gen = feed.generator!;
      final version = gen.version.isEmpty ? '' : ' v${gen.version}';
      final url = gen.url.isEmpty ? '' : ' (${gen.url})';
      _writeField(buffer, 'Generator', '${gen.name}$version$url');
    }

    // All links
    if (feed.links.isNotEmpty) {
      for (final link in feed.links) {
        final rel = ' [${link.rel}]';
        final type = link.type.isEmpty ? '' : ' (${link.type})';
        _writeField(buffer, 'Link$rel', link.href + type);
      }
    }

    // Authors
    if (feed.authors.isNotEmpty) {
      for (final author in feed.authors) {
        final email = author.email.isNotEmpty ? ' <${author.email}>' : '';
        final url = author.url != null ? ' [${author.url}]' : '';
        final type = author.type != null ? ' {${author.type!.name}}' : '';
        _writeField(buffer, 'Author', author.name + email + url + type);
      }
    }

    // Categories
    if (feed.categories.isNotEmpty) {
      for (final cat in feed.categories) {
        final scheme = cat.scheme != null ? ' [${cat.scheme}]' : '';
        final term = cat.term != null && cat.label != cat.term ? ' (${cat.term})' : '';
        _writeField(buffer, 'Category', '${cat.label}$term$scheme');
      }
    }

    // Images
    if (feed.image != null) {
      _writeField(buffer, 'Image URL', feed.image!.url);
      _writeField(buffer, 'Image Title', feed.image!.title);
      _writeField(buffer, 'Image Link', feed.image!.link);
      if (feed.image!.width != null) _writeField(buffer, 'Image Width', feed.image!.width.toString());
      if (feed.image!.height != null) _writeField(buffer, 'Image Height', feed.image!.height.toString());
      _writeField(buffer, 'Image Description', feed.image!.description);
    }

    if (feed.icon != null) {
      _writeField(buffer, 'Icon URL', feed.icon!.url);
      _writeField(buffer, 'Icon Title', feed.icon!.title);
    }

    // Extension data
    if (feed.syndication != null) {
      buffer.writeln();
      _writeSection(buffer, 'SYNDICATION EXTENSION');
      _writeField(buffer, 'Update Period', feed.syndication!.updatePeriod);
      _writeField(buffer, 'Update Frequency', feed.syndication!.updateFrequency?.toString());
      _writeField(buffer, 'Update Base', feed.syndication!.updateBase);
    }

    if (feed.podcast != null) {
      buffer.writeln();
      _writeSection(buffer, 'PODCAST/ITUNES EXTENSION');
      _writePodcastChannel(buffer, feed.podcast!);
    }

    // Items
    buffer.writeln();
    _writeSection(buffer, 'ITEMS (${feed.items.length})');
    for (var i = 0; i < feed.items.length; i++) {
      buffer.writeln();
      _writeItem(buffer, feed.items[i], i);
    }

    // Live items (podcast:liveItem)
    if (feed.liveItems.isNotEmpty) {
      buffer.writeln();
      _writeSection(buffer, 'LIVE ITEMS (${feed.liveItems.length})');
      for (var i = 0; i < feed.liveItems.length; i++) {
        buffer.writeln();
        _writeItem(buffer, feed.liveItems[i], i);
      }
    }

    // Issues
    if (result.issues.isNotEmpty) {
      buffer.writeln();
      _writeSection(buffer, 'ISSUES (${result.issues.length})');
      for (final issue in result.issues) {
        buffer.writeln(issue.toString());
      }
    }

    buffer
      ..writeln()
      ..writeln('═' * maxLineLength);

    return buffer.toString();
  }

  void _writeItem(StringBuffer buffer, Item item, int index) {
    buffer
      ..writeln('[$index] ${_truncate(item.title ?? "(untitled)", 80)}')
      ..writeln('  │');

    // Basic fields
    // Check if GUID is a permalink (isPermaLink=true, used as link)
    // When isPermaLink="true" in RSS, the guid value becomes item.link with rel=alternate
    final isPermalink =
        item.guid != null &&
        item.link != null &&
        item.link!.href == item.guid &&
        item.link!.rel == LinkRelationType.alternate;
    final permalinkTag = isPermalink ? ' [permalink]' : '';
    _writeField(buffer, 'GUID', item.guid != null ? '${item.guid}$permalinkTag' : null, indent: '  ├─ ');
    _writeField(buffer, 'Title', item.title, indent: '  ├─ ');
    _writeField(buffer, 'Copyright', item.copyright, indent: '  ├─ ');

    // Links
    _writeField(buffer, 'Link', item.link?.href, indent: '  ├─ ');
    if (item.links.isNotEmpty) {
      for (final link in item.links) {
        final rel = ' [${link.rel}]';
        final type = link.type.isEmpty ? '' : ' (${link.type})';
        _writeField(buffer, 'Link$rel', link.href + type, indent: '  ├─ ');
      }
    }

    // Timestamps
    _writeTimestamp(buffer, 'Published', item.published, indent: '  ├─ ');
    _writeTimestamp(buffer, 'Updated', item.updated, indent: '  ├─ ');

    // Authors
    if (item.authors.isNotEmpty) {
      for (final author in item.authors) {
        final type = author.type != null ? ' {${author.type!.name}}' : '';
        final email = author.email.isNotEmpty ? ' <${author.email}>' : '';
        final url = author.url != null ? ' [${author.url}]' : '';
        _writeField(buffer, 'Author', author.name + email + url + type, indent: '  ├─ ');
      }
    }

    // Categories
    if (item.categories.isNotEmpty) {
      for (final cat in item.categories) {
        final scheme = cat.scheme != null ? ' [${cat.scheme}]' : '';
        final term = cat.term != null && cat.label != cat.term ? ' (${cat.term})' : '';
        _writeField(buffer, 'Category', '${cat.label}$term$scheme', indent: '  ├─ ');
      }
    }

    // Image
    if (item.image != null) {
      _writeField(buffer, 'Image', item.image!.url, indent: '  ├─ ');
    }

    // Source
    if (item.source != null) {
      _writeField(buffer, 'Source', '${item.source!.href} [${item.source!.rel}]', indent: '  ├─ ');
    }

    // Source Entry (Atom)
    if (item.sourceEntry != null) {
      final src = item.sourceEntry!;
      _writeField(buffer, 'Source Entry', src.title, indent: '  ├─ ');
      if (src.guid != null) _writeField(buffer, 'Source GUID', src.guid, indent: '  │  ├─ ');
      if (src.updated != null) _writeTimestamp(buffer, 'Source Updated', src.updated, indent: '  │  └─ ');
    }

    // Comments
    if (item.comments != null) {
      _writeField(buffer, 'Comments', item.comments!.href, indent: '  ├─ ');
    }

    // Description (collapsed)
    if (item.description != null && item.description!.isNotEmpty) {
      final preview = _truncate(item.description!, maxContentPreview);
      _writeField(buffer, 'Description', preview, indent: '  ├─ ', collapsed: true);
    }

    // Content (collapsed)
    if (item.content.isNotEmpty) {
      for (final content in item.content) {
        final preview = _truncate(content.value, maxContentPreview);
        _writeField(
          buffer,
          'Content [${content.type}]',
          preview,
          indent: '  ├─ ',
          collapsed: true,
        );
      }
    }

    // Enclosures
    if (item.enclosures.isNotEmpty) {
      for (final enc in item.enclosures) {
        final size = enc.length.isNotEmpty ? ' (${enc.length} bytes)' : '';
        _writeField(buffer, 'Enclosure', '${enc.url} [${enc.type}]$size', indent: '  ├─ ');
      }
    }

    // Media RSS - show all details (only if has actual content)
    if (item.media != null) {
      final media = item.media!;
      final hasContent =
          media.title != null ||
          media.description != null ||
          media.content.isNotEmpty ||
          media.thumbnails.isNotEmpty ||
          media.credits.isNotEmpty ||
          media.rating.isNotEmpty ||
          media.categories.isNotEmpty ||
          media.group.isNotEmpty;

      if (hasContent) {
        buffer.writeln('  ├─ Media RSS:');
        _writeField(buffer, 'Title', media.title, indent: '  │  ├─ ');
        _writeField(buffer, 'Description', media.description, indent: '  │  ├─ ');
      }

      if (hasContent && media.content.isNotEmpty) {
        buffer.writeln('  │  ├─ Content (${media.content.length}):');
        for (var i = 0; i < media.content.length; i++) {
          final mc = media.content[i];
          final size = mc.fileSize != null ? ' (${mc.fileSize} bytes)' : '';
          final duration = mc.duration != null ? ' ${mc.duration}s' : '';
          _writeField(buffer, '[$i]', '${mc.url} [${mc.medium ?? mc.type}]$size$duration', indent: '  │  │  ├─ ');
          if (mc.width != null || mc.height != null) {
            _writeField(buffer, 'Size', '${mc.width}x${mc.height}', indent: '  │  │  │  ├─ ');
          }
        }
      }

      if (media.thumbnails.isNotEmpty) {
        buffer.writeln('  │  ├─ Thumbnails (${media.thumbnails.length}):');
        for (var i = 0; i < media.thumbnails.length; i++) {
          final thumb = media.thumbnails[i];
          final size = thumb.width != null && thumb.height != null ? ' [${thumb.width}x${thumb.height}]' : '';
          _writeField(buffer, '[$i]', '${thumb.url}$size', indent: '  │  │  ├─ ');
        }
      }

      if (hasContent && media.credits.isNotEmpty) {
        _writeField(
          buffer,
          'Credits',
          media.credits.map((c) => '${c.value} (${c.role})').join(', '),
          indent: '  │  ├─ ',
        );
      }

      if (hasContent && media.rating.isNotEmpty) {
        _writeField(
          buffer,
          'Ratings',
          media.rating.map((r) => '${r.scheme}: ${r.value}').join(', '),
          indent: '  │  ├─ ',
        );
      }

      if (hasContent && media.categories.isNotEmpty) {
        _writeField(buffer, 'Categories', media.categories.map((c) => c.term).join(', '), indent: '  │  ├─ ');
      }

      // Display media groups (e.g., YouTube feeds use media:group)
      if (media.group.isNotEmpty) {
        for (var groupIdx = 0; groupIdx < media.group.length; groupIdx++) {
          final group = media.group[groupIdx];
          buffer.writeln('  │  ├─ Media Group [$groupIdx]:');
          _writeField(buffer, 'Title', group.title, indent: '  │  │  ├─ ');
          _writeField(buffer, 'Description', group.description, indent: '  │  │  ├─ ');

          if (group.content.isNotEmpty) {
            buffer.writeln('  │  │  ├─ Content (${group.content.length}):');
            for (var i = 0; i < group.content.length; i++) {
              final mc = group.content[i];
              final size = mc.fileSize != null ? ' (${mc.fileSize} bytes)' : '';
              final duration = mc.duration != null ? ' ${mc.duration}s' : '';
              _writeField(
                buffer,
                '[$i]',
                '${mc.url} [${mc.medium ?? mc.type}]$size$duration',
                indent: '  │  │  │  ├─ ',
              );
              if (mc.width != null || mc.height != null) {
                _writeField(buffer, 'Size', '${mc.width}x${mc.height}', indent: '  │  │  │  │  ├─ ');
              }
            }
          }

          if (group.thumbnails.isNotEmpty) {
            buffer.writeln('  │  │  ├─ Thumbnails (${group.thumbnails.length}):');
            for (var i = 0; i < group.thumbnails.length; i++) {
              final thumb = group.thumbnails[i];
              final size = thumb.width != null && thumb.height != null ? ' [${thumb.width}x${thumb.height}]' : '';
              _writeField(buffer, '[$i]', '${thumb.url}$size', indent: '  │  │  │  ├─ ');
            }
          }

          if (group.credits.isNotEmpty) {
            _writeField(
              buffer,
              'Credits',
              group.credits.map((c) => '${c.value} (${c.role})').join(', '),
              indent: '  │  │  ├─ ',
            );
          }

          if (group.rating.isNotEmpty) {
            _writeField(
              buffer,
              'Ratings',
              group.rating.map((r) => '${r.scheme}: ${r.value}').join(', '),
              indent: '  │  │  ├─ ',
            );
          }

          if (group.categories.isNotEmpty) {
            _writeField(buffer, 'Categories', group.categories.map((c) => c.term).join(', '), indent: '  │  │  └─ ');
          }
        }
      }
    }

    // Podcast extension - show all details
    if (item.podcast != null) {
      _writePodcastItem(buffer, item.podcast!);
    }

    // GeoRSS - show all fields (only if has actual content)
    if (item.geo != null) {
      final geo = item.geo!;
      final hasGeoContent =
          geo.line != null ||
          geo.polygon != null ||
          geo.box != null ||
          geo.featureTypeTag != null ||
          geo.relationshipTag != null ||
          geo.featureName != null ||
          geo.elev != null ||
          geo.floor != null ||
          geo.radius != null;

      if (hasGeoContent) {
        buffer.writeln('  ├─ GeoRSS:');
        _writeField(buffer, 'Line', geo.line, indent: '  │  ├─ ');
        _writeField(buffer, 'Polygon', geo.polygon, indent: '  │  ├─ ');
        _writeField(buffer, 'Box', geo.box, indent: '  │  ├─ ');
        _writeField(buffer, 'Feature Type', geo.featureTypeTag, indent: '  │  ├─ ');
        _writeField(buffer, 'Relationship', geo.relationshipTag, indent: '  │  ├─ ');
        _writeField(buffer, 'Feature Name', geo.featureName, indent: '  │  ├─ ');
        _writeField(buffer, 'Elevation', geo.elev, indent: '  │  ├─ ');
        _writeField(buffer, 'Floor', geo.floor, indent: '  │  ├─ ');
        _writeField(buffer, 'Radius', geo.radius, indent: '  │  └─ ');
      }
    }

    // DC Terms - show all fields (only if has actual content)
    if (item.dcterms != null) {
      final dc = item.dcterms!;
      final hasDcContent =
          dc.created != null || dc.modified != null || dc.issued != null || dc.valid != null || dc.available != null;

      if (hasDcContent) {
        buffer.writeln('  ├─ DC Terms:');
        _writeField(buffer, 'Created', dc.created, indent: '  │  ├─ ');
        _writeField(buffer, 'Modified', dc.modified, indent: '  │  ├─ ');
        _writeField(buffer, 'Issued', dc.issued, indent: '  │  ├─ ');
        if (dc.valid != null) {
          _writeField(buffer, 'Valid', '${dc.valid!.start} to ${dc.valid!.end}', indent: '  │  ├─ ');
        }
        if (dc.available != null) {
          _writeField(buffer, 'Available', '${dc.available!.start} to ${dc.available!.end}', indent: '  │  └─ ');
        }
      }
    }
  }

  void _writePodcastChannel(StringBuffer buffer, PodcastChannel pod) {
    // iTunes vocabulary
    _writeField(buffer, 'Summary', pod.summary);
    _writeField(buffer, 'Explicit', pod.explicit?.toString());
    _writeField(buffer, 'Type', pod.type);
    _writeField(buffer, 'Complete', pod.complete?.toString());
    _writeField(buffer, 'Block', pod.block);
    _writeField(buffer, 'New Feed URL', pod.newFeedUrl);
    if (pod.image != null) {
      _writeField(buffer, 'iTunes Image', pod.image!.url);
    }
    if (pod.categories.isNotEmpty) {
      for (final cat in pod.categories) {
        final scheme = cat.scheme != null ? ' [${cat.scheme}]' : '';
        _writeField(buffer, 'Category', '${cat.label}$scheme');
        for (final child in cat.children) {
          final childScheme = child.scheme != null ? ' [${child.scheme}]' : '';
          _writeField(buffer, '  └─ Subcategory', '${child.label}$childScheme');
        }
      }
    }

    // Podcast Index vocabulary - scalars
    _writeField(buffer, 'GUID', pod.guid);
    if (pod.medium != null) {
      final listSuffix = pod.mediumIsList ? ' [list]' : '';
      _writeField(buffer, 'Medium', '${pod.medium} (${pod.knownMedium.name})$listSuffix');
    }
    _writeField(buffer, 'Podping uses', pod.podpingUsesPodping?.toString());
    if (pod.locked != null) {
      final owner = pod.lockedOwner != null ? ' <${pod.lockedOwner}>' : '';
      _writeField(buffer, 'Locked', '${pod.locked}$owner');
    }
    if (pod.updateFrequency != null) {
      final u = pod.updateFrequency!;
      final parts = <String>[
        if (u.description != null) u.description!,
        if (u.rrule != null) 'rrule=${u.rrule}',
        if (u.dtstart != null) 'dtstart=${u.dtstart!.value}',
        if (u.complete != null) 'complete=${u.complete}',
      ];
      _writeField(buffer, 'Update Frequency', parts.join(' | '));
    }
    if (pod.license != null) _writeField(buffer, 'License', _formatLicense(pod.license!));
    if (pod.chat != null) _writeField(buffer, 'Chat', _formatChat(pod.chat!));
    if (pod.publisher != null) {
      _writeField(buffer, 'Publisher', _formatRemoteItem(pod.publisher!.remoteItem));
    }

    // Podcast Index vocabulary - lists
    if (pod.podroll != null) {
      buffer.writeln('Podroll (${pod.podroll!.items.length}):');
      for (var i = 0; i < pod.podroll!.items.length; i++) {
        _writeField(buffer, '[$i]', _formatRemoteItem(pod.podroll!.items[i]), indent: '  ');
      }
    }
    if (pod.trailers.isNotEmpty) {
      buffer.writeln('Trailers (${pod.trailers.length}):');
      for (var i = 0; i < pod.trailers.length; i++) {
        _writeField(buffer, '[$i]', _formatTrailer(pod.trailers[i]), indent: '  ');
      }
    }
    if (pod.fundings.isNotEmpty) {
      buffer.writeln('Funding (${pod.fundings.length}):');
      for (var i = 0; i < pod.fundings.length; i++) {
        final f = pod.fundings[i];
        final text = f.text ?? '(no text)';
        _writeField(buffer, '[$i]', '$text → ${f.url ?? "(no url)"}', indent: '  ');
      }
    }
    if (pod.persons.isNotEmpty) {
      buffer.writeln('Persons (${pod.persons.length}):');
      for (var i = 0; i < pod.persons.length; i++) {
        _writeField(buffer, '[$i]', _formatPerson(pod.persons[i]), indent: '  ');
      }
    }
    if (pod.locations.isNotEmpty) {
      buffer.writeln('Locations (${pod.locations.length}):');
      for (var i = 0; i < pod.locations.length; i++) {
        _writeField(buffer, '[$i]', _formatLocation(pod.locations[i]), indent: '  ');
      }
    }
    if (pod.blocks.isNotEmpty) {
      buffer.writeln('Blocks (${pod.blocks.length}):');
      for (var i = 0; i < pod.blocks.length; i++) {
        final b = pod.blocks[i];
        final target = b.id ?? '*global*';
        _writeField(buffer, '[$i]', '$target: ${b.value} (blocked=${b.blocked})', indent: '  ');
      }
    }
    if (pod.images.isNotEmpty) {
      buffer.writeln('Images (${pod.images.length}):');
      for (var i = 0; i < pod.images.length; i++) {
        _writeField(buffer, '[$i]', _formatPodcastImage(pod.images[i]), indent: '  ');
      }
    }
    if (pod.txts.isNotEmpty) {
      buffer.writeln('TXT entries (${pod.txts.length}):');
      for (var i = 0; i < pod.txts.length; i++) {
        final t = pod.txts[i];
        final purpose = t.purpose != null ? ' [${t.purpose}]' : '';
        _writeField(buffer, '[$i]', '${t.value}$purpose', indent: '  ');
      }
    }
    if (pod.values.isNotEmpty) {
      buffer.writeln('Values (${pod.values.length}):');
      for (var i = 0; i < pod.values.length; i++) {
        _writePodcastValueEntry(buffer, pod.values[i], i, indent: '  ');
      }
    }
    if (pod.remoteItems.isNotEmpty) {
      buffer.writeln('Remote Items (${pod.remoteItems.length}):');
      for (var i = 0; i < pod.remoteItems.length; i++) {
        _writeField(buffer, '[$i]', _formatRemoteItem(pod.remoteItems[i]), indent: '  ');
      }
    }
  }

  void _writePodcastItem(StringBuffer buffer, PodcastItem pod) {
    buffer.writeln('  ├─ Podcast:');
    const i1 = '  │  ├─ ';
    const i2 = '  │  │  ├─ ';

    _writeField(buffer, 'Title', pod.title, indent: i1);
    _writeField(buffer, 'Duration', pod.duration, indent: i1);
    if (pod.episode != null) {
      final display = pod.episodeDisplay != null ? ' (display: "${pod.episodeDisplay}")' : '';
      _writeField(buffer, 'Episode', '${pod.episode}$display', indent: i1);
    }
    if (pod.season != null) {
      final name = pod.seasonName != null ? ' (name: "${pod.seasonName}")' : '';
      _writeField(buffer, 'Season', '${pod.season}$name', indent: i1);
    }
    _writeField(buffer, 'Episode Type', pod.episodeType, indent: i1);
    _writeField(buffer, 'Explicit', pod.explicit, indent: i1);
    _writeField(buffer, 'Block', pod.block, indent: i1);
    _writeField(buffer, 'Summary', pod.summary, indent: i1);
    if (pod.image != null) _writeField(buffer, 'Image', pod.image!.url, indent: i1);

    if (pod.live != null) {
      final l = pod.live!;
      final parts = <String>[
        'status=${l.knownStatus.name}',
        if (l.start != null) 'start=${l.start!.value}',
        if (l.end != null) 'end=${l.end!.value}',
      ];
      _writeField(buffer, 'Live', parts.join(' | '), indent: i1);
    }

    if (pod.chapters != null) {
      final c = pod.chapters!;
      _writeField(buffer, 'Chapters', '${c.url ?? "(no url)"} [${c.type ?? "?"}]', indent: i1);
    }
    if (pod.license != null) {
      _writeField(buffer, 'License', _formatLicense(pod.license!), indent: i1);
    }
    if (pod.chat != null) {
      _writeField(buffer, 'Chat', _formatChat(pod.chat!), indent: i1);
    }

    if (pod.transcripts.isNotEmpty) {
      buffer.writeln('$i1 Transcripts (${pod.transcripts.length}):');
      for (var i = 0; i < pod.transcripts.length; i++) {
        final t = pod.transcripts[i];
        final parts = <String>[
          t.url ?? '(no url)',
          if (t.type != null) '[${t.type}/${t.knownType.name}]',
          if (t.language != null) 'lang=${t.language}',
          if (t.rel != null) 'rel=${t.rel}',
        ];
        _writeField(buffer, '[$i]', parts.join(' '), indent: i2);
      }
    }
    if (pod.persons.isNotEmpty) {
      buffer.writeln('$i1 Persons (${pod.persons.length}):');
      for (var i = 0; i < pod.persons.length; i++) {
        _writeField(buffer, '[$i]', _formatPerson(pod.persons[i]), indent: i2);
      }
    }
    if (pod.locations.isNotEmpty) {
      buffer.writeln('$i1 Locations (${pod.locations.length}):');
      for (var i = 0; i < pod.locations.length; i++) {
        _writeField(buffer, '[$i]', _formatLocation(pod.locations[i]), indent: i2);
      }
    }
    if (pod.soundbites.isNotEmpty) {
      buffer.writeln('$i1 Soundbites (${pod.soundbites.length}):');
      for (var i = 0; i < pod.soundbites.length; i++) {
        final s = pod.soundbites[i];
        final title = s.title != null ? ' "${s.title}"' : '';
        _writeField(buffer, '[$i]', 'start=${s.startTime} dur=${s.duration}$title', indent: i2);
      }
    }
    if (pod.socialInteracts.isNotEmpty) {
      buffer.writeln('$i1 Social Interacts (${pod.socialInteracts.length}):');
      for (var i = 0; i < pod.socialInteracts.length; i++) {
        final s = pod.socialInteracts[i];
        final parts = <String>[
          s.protocol,
          if (s.uri != null) s.uri!,
          if (s.accountId != null) 'account=${s.accountId}',
          if (s.priority != null) 'priority=${s.priority}',
        ];
        _writeField(buffer, '[$i]', parts.join(' | '), indent: i2);
      }
    }
    if (pod.images.isNotEmpty) {
      buffer.writeln('$i1 Images (${pod.images.length}):');
      for (var i = 0; i < pod.images.length; i++) {
        _writeField(buffer, '[$i]', _formatPodcastImage(pod.images[i]), indent: i2);
      }
    }
    if (pod.alternateEnclosures.isNotEmpty) {
      buffer.writeln('$i1 Alternate Enclosures (${pod.alternateEnclosures.length}):');
      for (var i = 0; i < pod.alternateEnclosures.length; i++) {
        _writeAlternateEnclosure(buffer, pod.alternateEnclosures[i], i);
      }
    }
    if (pod.values.isNotEmpty) {
      buffer.writeln('$i1 Values (${pod.values.length}):');
      for (var i = 0; i < pod.values.length; i++) {
        _writePodcastValueEntry(buffer, pod.values[i], i, indent: i2);
      }
    }
    if (pod.contentLinks.isNotEmpty) {
      buffer.writeln('$i1 Content Links (${pod.contentLinks.length}):');
      for (var i = 0; i < pod.contentLinks.length; i++) {
        final c = pod.contentLinks[i];
        final text = c.text != null ? ' — ${c.text}' : '';
        _writeField(buffer, '[$i]', '${c.href}$text', indent: i2);
      }
    }
    if (pod.txts.isNotEmpty) {
      buffer.writeln('$i1 TXT entries (${pod.txts.length}):');
      for (var i = 0; i < pod.txts.length; i++) {
        final t = pod.txts[i];
        final purpose = t.purpose != null ? ' [${t.purpose}]' : '';
        _writeField(buffer, '[$i]', '${t.value}$purpose', indent: i2);
      }
    }
  }

  void _writeAlternateEnclosure(StringBuffer buffer, PodcastAlternateEnclosure alt, int index) {
    const i3 = '  │  │  ├─ ';
    const i4 = '  │  │  │  ├─ ';
    final hdrParts = <String>[
      if (alt.type != null) alt.type!,
      if (alt.title != null) '"${alt.title}"',
      if (alt.bitrate != null) 'bitrate=${alt.bitrate}',
      if (alt.height != null) 'h=${alt.height}',
      if (alt.lang != null) 'lang=${alt.lang}',
      if (alt.rel != null) 'rel=${alt.rel}',
      if (alt.codecs != null) 'codecs=${alt.codecs}',
      if (alt.length != null) '${alt.length}B',
      if (alt.isDefault ?? false) 'default',
    ];
    _writeField(buffer, '[$index]', hdrParts.join(' | '), indent: i3);
    for (var s = 0; s < alt.sources.length; s++) {
      final src = alt.sources[s];
      final ct = src.contentType != null ? ' [${src.contentType}]' : '';
      _writeField(buffer, 'src[$s]', '${src.uri}$ct', indent: i4);
    }
    for (var k = 0; k < alt.integrity.length; k++) {
      final ig = alt.integrity[k];
      _writeField(buffer, 'integrity[$k]', '${ig.type}: ${_truncate(ig.value, 60)}', indent: i4);
    }
  }

  void _writePodcastValueEntry(StringBuffer buffer, PodcastValue v, int index, {required String indent}) {
    final hdrParts = <String>[
      '${v.type}/${v.method}',
      if (v.suggested != null) 'suggested=${v.suggested}',
      'recipients=${v.recipients.length}',
      if (v.timeSplits.isNotEmpty) 'timeSplits=${v.timeSplits.length}',
    ];
    _writeField(buffer, '[$index]', hdrParts.join(' | '), indent: indent);
    for (var r = 0; r < v.recipients.length; r++) {
      final rec = v.recipients[r];
      final name = rec.name != null ? '"${rec.name}" ' : '';
      final fee = (rec.fee ?? false) ? ' [fee]' : '';
      _writeField(buffer, '  r[$r]', '$name${rec.type}:${rec.address} split=${rec.split}$fee', indent: indent);
    }
    for (var t = 0; t < v.timeSplits.length; t++) {
      final ts = v.timeSplits[t];
      final remote = ts.remoteItem != null ? ' → remote(${ts.remoteItem!.feedGuid})' : '';
      _writeField(buffer, '  ts[$t]', 'start=${ts.startTime} dur=${ts.duration}$remote', indent: indent);
    }
  }

  String _formatLicense(PodcastLicense l) {
    final parts = <String>[
      if (l.spdx != null) l.spdx!,
      if (l.text != null) '"${l.text}"',
      if (l.url != null) l.url!,
    ];
    return parts.join(' | ');
  }

  String _formatChat(PodcastChat c) {
    final parts = <String>[
      '${c.protocol}://${c.server}',
      if (c.space != null) 'space=${c.space}',
      if (c.accountId != null) 'account=${c.accountId}',
    ];
    return parts.join(' | ');
  }

  String _formatTrailer(PodcastTrailer t) {
    final parts = <String>[
      if (t.title != null) '"${t.title}"',
      t.url,
      if (t.type != null) '[${t.type}]',
      if (t.length != null) '${t.length}B',
      if (t.season != null) 'season=${t.season}',
      if (t.pubdate != null) 'pubdate=${t.pubdate!.value}',
    ];
    return parts.join(' | ');
  }

  String _formatPerson(PodcastPerson p) {
    final parts = <String>[
      p.name,
      '${p.effectiveRole}/${p.effectiveGroup}',
      if (p.href != null) p.href!,
      if (p.img != null) 'img=${p.img}',
    ];
    return parts.join(' | ');
  }

  String _formatLocation(PodcastLocation l) {
    final parts = <String>[
      l.text,
      if (l.rel != null) 'rel=${l.rel}',
      if (l.geo != null) 'geo=${l.geo}',
      if (l.osm != null) 'osm=${l.osm}',
      if (l.country != null) 'country=${l.country}',
    ];
    return parts.join(' | ');
  }

  String _formatPodcastImage(PodcastImage img) {
    final parts = <String>[
      img.href,
      if (img.alt != null) 'alt="${img.alt}"',
      if (img.purpose != null) 'purpose=${img.purpose}',
      if (img.aspectRatio != null) 'AR=${img.aspectRatio}',
      if (img.width != null || img.height != null) '${img.width ?? "?"}x${img.height ?? "?"}',
      if (img.type != null) img.type!,
    ];
    return parts.join(' | ');
  }

  String _formatRemoteItem(PodcastRemoteItem r) {
    final parts = <String>[
      if (r.title != null) '"${r.title}"',
      'feedGuid=${r.feedGuid}',
      if (r.itemGuid != null) 'itemGuid=${r.itemGuid}',
      if (r.feedUrl != null) 'feedUrl=${r.feedUrl}',
      if (r.medium != null) 'medium=${r.medium}',
    ];
    return parts.join(' | ');
  }

  void _writeSection(StringBuffer buffer, String title) {
    buffer
      ..writeln('─' * maxLineLength)
      ..writeln(title)
      ..writeln('─' * maxLineLength);
  }

  void _writeField(
    StringBuffer buffer,
    String label,
    String? value, {
    String indent = '',
    bool collapsed = false,
  }) {
    if (value == null || value.isEmpty) return;

    final marker = collapsed ? '▸' : ' ';
    final chars = value.length > maxContentPreview ? ' [${value.length} chars]' : '';
    buffer.writeln('$indent$marker $label: $value$chars');
  }

  void _writeTimestamp(
    StringBuffer buffer,
    String label,
    Timestamp? timestamp, {
    String indent = '',
  }) {
    if (timestamp == null) return;

    final parsed = timestamp.parseValue();
    if (parsed != null) {
      buffer.writeln('$indent  $label: ${parsed.toIso8601String()} ← "${timestamp.value}"');
    } else {
      buffer.writeln('$indent  $label: [PARSE FAILED] "${timestamp.value}"');
    }
  }

  // Simple HTML stripping - remove tags and decode common entities
  String _truncate(String text, int maxLength, {bool stripHtml = false}) {
    var result = text.trim();

    if (stripHtml) {
      result = result
          .replaceAll(RegExp('<[^>]*>'), '')
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&amp;', '&')
          .replaceAll('&quot;', '"')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
    }

    if (result.length <= maxLength) return result;

    return '${result.substring(0, maxLength)}... (+${result.length - maxLength} more)';
  }
}
