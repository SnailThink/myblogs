### ResponseEntity的返回值用法

#### 1.Get请求时

```java
/**
 * 查询
 *
 * @param name
 * @return
 */
@GetMapping("/queryUserById")
public ResponseEntity queryUserById(@RequestParam("name") String name) {
	OrmUserPO ormUserPO = ormUserService.queryOrmUserByName(name);
	return ResponseEntity.ok(ormUserPO);
}
```

#### 2.1 Post请求新增一条记录时,有返回值

**return ResponseEntity.status(HttpStatus.CREATE).body();()存放返回的内容**

```java
	/**
	 * 新增
	 *
	 * @param userVO
	 * @return
	 */
	@PostMapping("/addOrmUser")
	public ResponseEntity addOrmUser(@RequestBody OrmUserVO userVO) {
		OrmUserPO ormUserPO = new OrmUserPO();
		//bean  copyProperties(数据源，目标源)；
		BeanUtils.copyProperties(userVO, ormUserPO);
		return ResponseEntity.status(HttpStatus.CREATED).body(this.ormUserService.addOrmUser(ormUserPO));
	}
```



#### 2.2 Post请求新增一条记录时,有无回值

**return new ResponseEntity(HttpStatus.CREATED); **

```

	/**
	 * 新增
	 *
	 * @param userVO
	 * @return
	 */
	@PostMapping("/addOrmUser")
	public ResponseEntity addOrmUser(@RequestBody OrmUserVO userVO) {
		OrmUserPO ormUserPO = new OrmUserPO();
		//bean  copyProperties(数据源，目标源)；
		BeanUtils.copyProperties(userVO, ormUserPO);
		return new ResponseEntity(HttpStatus.CREATED);
	}

```



#### 3.1 Delete删除请求,无返回

**return new ResponseEntity(HttpStatus.NO_CONTENT); **



```java
/**
	 * 删除
	 *
	 * @param id
	 * @return
	 */
	@DeleteMapping("/deleteOrmUserById")
	public ResponseEntity deleteOrmUserById(@RequestParam("id") Integer id) {
		return ResponseEntity.ok(this.ormUserService.deleteOrmUser(id));
	}

```

#### 4.Put更新请求，无返回值

**ResponseEntity.noContent().build(); **



```java
/**
	 * 修改
	 *
	 * @param ormUserPO
	 * @return
	 */
	@PutMapping("/updateUserById")
	public ResponseEntity updateUserById(@RequestBody OrmUserPO ormUserPO) {
		return ResponseEntity.ok(this.ormUserService.updateOrmUser(ormUserPO));
	}


```

