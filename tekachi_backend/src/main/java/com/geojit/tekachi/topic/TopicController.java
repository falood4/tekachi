package com.geojit.tekachi.topic;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.geojit.tekachi.topic.entity.Title;
import com.geojit.tekachi.topic.services.ContentService;
import com.geojit.tekachi.topic.services.TitleService;

@RestController
public class TopicController {
    private final TitleService titleService;
    private final ContentService contentService;

    public TopicController(TitleService titleService, ContentService contentService) {
        this.titleService = titleService;
        this.contentService = contentService;
    }

    @GetMapping("/topics")
    public Map<String, Integer> getTopics(@RequestParam Integer low, @RequestParam Integer high) {
        return titleService.findTopics(low, high).stream()
                .collect(Collectors.toMap(
                        titleView -> titleView.getTitleString(),
                        titleView -> titleView.getTopicId(),
                        (existing, replacement) -> existing,
                        LinkedHashMap::new));
    }

    @GetMapping("/topics/{titleId}")
    public String getTopicContent(@PathVariable Integer titleId) {
        Title topicTitle = titleService.findById(titleId);
        return contentService.findByTitle(topicTitle).getContent();
    }

}
