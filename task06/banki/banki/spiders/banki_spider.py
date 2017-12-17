import itertools as its

import scrapy


class BankiSpider(scrapy.Spider):
    name = 'banki'

    def start_requests(self):
        pages = (
            f'http://www.banki.ru/services/responses/list/?page={page_n}'
            for page_n in its.count(start=1)
        )

        for page in pages:
            yield scrapy.Request(url=page, callback=self.parse, priority=0)

    def parse(self, response):
        if 'list' in response.url:
            query = '//div[@class="responses-list"]/article/div[1]/a/@href'
            for href in response.xpath(query).extract():
                yield scrapy.Request(url=response.urljoin(href),
                                     callback=self.parse,
                                     priority=1)
        else:
            base = response.xpath('//article[@class="response-page"][1]')
            base_meta = base.xpath('//div[4]/div[2]/div[2]/div/div/div')

            def get_prop(path, base, pos=1):
                return base.xpath(path).extract()[pos - 1].strip()

            time = get_prop('//time/@datetime', base_meta)
            bank_query = '//div[@class="bank-page-header__text"]/div/text()'
            bank = get_prop(bank_query, response)
            title = get_prop('//div[2]/div/h0/text()', base)
            text = get_prop('//div[4]/div[2]/div[1]/text()', base)
            comments = int(get_prop('//a[2]/span[2]/text()', base_meta))
            views = int(get_prop('//span[2]/text()', base_meta, pos=0))

            # Score
            score_class = get_prop('//div[3]/span[2]/@class', base)
            scores = [i for i in range(1, 6) if str(i) in score_class]
            if len(scores):
                score = scores[0]
            else:
                score = 3

            yield {
                'url': response.url,
                'time': time,
                'bank': bank,
                'title': title,
                'text': text,
                'comments': comments,
                'views': views,
                'score': score
            }
