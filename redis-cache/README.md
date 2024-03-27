# Redis Cache

## Cache
한 번 처리한 데이터를 임시로 저장소에 저장하는 것으로 임시 데이터와 동일하거나 유사한 요청이 왔을 경우 저장소에서 바로 읽어와 성능 및 응답속도 향상을 위해 사용합니다.

<br>

## Spring에 Redis Cache 적용하기

~~~

@Configuration
@EnableCaching
public class RedisCacheConfig {

    @Value("${inkbridge.redis.host}")
    private String host;
    @Value("${inkbridge.redis.port}")
    private String port;
    @Value("${inkbridge.redis.password}")
    private String password;
    @Value("${inkbridge.redis.database.cache}")
    private String database;

    @Bean
    public RedisConnectionFactory redisConnectionFactoryForCache() {
        RedisStandaloneConfiguration configuration = new RedisStandaloneConfiguration();
        configuration.setHostName(host);
        configuration.setPort(Integer.parseInt(port));
        configuration.setPassword(password);
        configuration.setDatabase(Integer.parseInt(database));

        return new LettuceConnectionFactory(configuration);
    }
~~~
- 캐시용 RedisConnectionFactory를 설정합니다. host, port, password, database를 입력합니다.

<br>

~~~
    @Bean
    public CacheManager cacheManager() {
        GenericJackson2JsonRedisSerializer serializer = new GenericJackson2JsonRedisSerializer(
            objectMapper());

        RedisSerializationContext.SerializationPair<Object> serializationPair =
            RedisSerializationContext.SerializationPair.fromSerializer(serializer);

        RedisCacheConfiguration redisCacheConfiguration = RedisCacheConfiguration.defaultCacheConfig()
            .serializeValuesWith(serializationPair)
            .entryTtl(Duration.ofMinutes(3L));

        return RedisCacheManager.RedisCacheManagerBuilder.fromConnectionFactory(
            redisConnectionFactoryForCache()).cacheDefaults(redisCacheConfiguration).build();
    }
~~~
- CacheManager를 설정합니다. CacheManager 구현체 종류는 [링크](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/cache/CacheManager.html)를 참고해주세요.
- Serializer를 설정합니다. 캐시는 메모리에 key-value 형식으로 저장하기 때문에 key와 value 값에 대한 직렬화 설정이 필요합니다.
  - serializeKeyWith: key값에 대한 직렬화 설정
  - serializeValuesWith: value값에 대한 직렬화 설정
  - entryTtl(선택 사항): 저장된 캐시의 만료시간을 의미합니다. 저는 3분으로 설정하였습니다.
<br>

~~~
    private ObjectMapper objectMapper() {
        PolymorphicTypeValidator validator = BasicPolymorphicTypeValidator.builder().allowIfSubType(
            Object.class).build();
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.activateDefaultTyping(validator, DefaultTyping.NON_FINAL);
        return objectMapper;
    }
}
~~~
- 위에서 사용할 objectMapper를 생성합니다. 다양한 직렬화 방법이 있으나 데이터에 LocalDate가 들어가기 때문에 jackson:jsr310를 위해 따로 ObjectMapper를 custom 하였습니다.
  -  registerModule() : 추가하고 싶은 모듈을 추가할 수 있습니다. 여기서는 JavaTimeModule을 추가하여 LocalDateTime 역직렬화를 가능하도록 하였습니다.
  -  activateDefaultTyping() : 직렬화 시 type 정보를 저장할 scope를 지정합니다. 여기서는 non-final 클래스들에 대해 타입 정보를 저장할 수 있도록 했습니다.(GenericJackson2JsonRedisSerializer의 기본 동작 방식)


<br>

~~~
    @Override
    @Cacheable(value = "Book", key = "#field", cacheManager = "cacheManager")
    public PageRequestDto<BookSearchResponseDto> searchByAll(String field, Pageable pageable) {
        return searchAdaptor.searchByAll(field, pageable);
~~~
- @Cacheable을 사용했습니다. 데이터를 캐싱하거나 조회할 때 사용하는 어노테이션입니다. 설정 시 속성에는 SpEl 문법이 사용됩니다.
  - value : 데이터가 저장되는 이름입니다.
  - key : 데이터가 저장될 key 값입니다. 커스텀해서 정의하거나, KeyGenerator를 따로 선언해서 사용할 수 있습니다. 저는 #field과 같이 #로 매개변수값을 활용해 key를 설정했습니다.
  - condition(optional): 캐싱이 될 조건을 설정합니다. 따로 설정하지는 않았습니다.

  <details>
  <summary>캐싱 관련 annotation</summary>
  <div markdown="1">
    <ol>
      <li>@Cacheable : 데이터를 캐싱하거나 조회</li>
      <li>@CacheEvict : 캐싱된 데이터를 삭제</li>
      <li>@CachePut : 데이터를 캐싱</li>
      <li>@Caching : 여러 캐싱 어노테이션을 적용할때 사용</li>
      <li>@CacheConfig : 클래스 단계에서 공통적으로 글로벌하게 설정을 적용할때 사용</li>
    </ol>
  </div>
  </details>

<br>

~~~
@EnableCaching
@ConfigurationPropertiesScan
@SpringBootApplication
public class FrontApplication {

	public static void main(String[] args) {
		SpringApplication.run(FrontApplication.class, args);
	}

}
~~~
Caching 기능이 활용될 것을 명시해주기 위해 @EnableCaching annotation을 사용합니다.
<br>

## REFERENCE
https://docs.spring.io/spring-data/redis/reference/redis/redis-cache.html
https://velog.io/@hwsa1004/Spring-Redis-Cache%EB%A5%BC-%ED%86%B5%ED%95%B4-%EC%84%B1%EB%8A%A5-%EA%B0%9C%EC%84%A0%ED%95%98%EA%B8%B0
https://medium.com/garimoo/%EA%B0%9C%EB%B0%9C%EC%9E%90%EB%A5%BC-%EC%9C%84%ED%95%9C-%EB%A0%88%EB%94%94%EC%8A%A4-%ED%8A%9C%ED%86%A0%EB%A6%AC%EC%96%BC-02-f1029893e263
https://velog.io/@bagt/Redis-%EC%97%AD%EC%A7%81%EB%A0%AC%ED%99%94-%EC%82%BD%EC%A7%88%EA%B8%B0-feat.-RedisSerializer
